import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';

/// Exception classes for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class WeakPasswordException extends AuthException {
  WeakPasswordException()
      : super('Password is too weak. Use at least 6 characters with uppercase, lowercase, and numbers.');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('This email is already registered. Please sign in instead.');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('Please enter a valid email address.');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found. Please check your email.');
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('Incorrect password. Please try again.');
}

class NetworkException extends AuthException {
  NetworkException() : super('Network error. Please check your connection.');
}

/// User model for storing user data
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String role; // "user" | "admin"

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.role = 'user',
  });

  /// Whether this user has admin privileges
  bool get isAdmin => role == 'admin';

  /// Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role,
    };
  }

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: json['role'] as String? ?? 'user',
    );
  }
}

/// Authentication Service - handles all auth operations
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  late SharedPreferences _prefs;
  User? _currentUser;
  late FirebaseFirestore _firestore;
  late firebase_auth.FirebaseAuth _auth;

  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sessionTokenKey = 'session_token';

  /// Initialize the auth service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _firestore = FirebaseFirestore.instance;
    _auth = firebase_auth.FirebaseAuth.instance;
    await _restoreSession();
  }

  /// Restore user session from SharedPreferences
  Future<void> _restoreSession() async {
    try {
      final isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
      final userJson = _prefs.getString(_userKey);

      if (isLoggedIn && userJson != null) {
        _currentUser = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error restoring session: $e');
      _currentUser = null;
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Check if current user is an admin
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Get current user
  User? get currentUser => _currentUser;

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Register a new user with Firebase Authentication + Firestore
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || !_isValidEmail(email)) {
        throw InvalidEmailException();
      }
      if (password.isEmpty || !_isValidPassword(password)) {
        throw WeakPasswordException();
      }
      if (name.isEmpty) {
        throw AuthException('Please enter your name.');
      }

      // Create user with Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Failed to create user account.');
      }

      // Create user object
      final newUser = User(
        id: firebaseUser.uid,
        email: email.toLowerCase(),
        name: name,
      );

      // Save user profile to Firestore users/{uid}
      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'email': email.toLowerCase(),
        'name': name,
        'role': 'user',
        'profileImageUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      await _saveUserSession(newUser);
      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw AuthException(e.message ?? 'Registration failed.');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Firebase Authentication + Firestore profile lookup
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('=== SIGN IN START ===');
      print('Email: $email');

      if (email.isEmpty || !_isValidEmail(email)) {
        throw InvalidEmailException();
      }
      if (password.isEmpty) {
        throw AuthException('Please enter your password.');
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Sign in failed.');
      }

      print('Firebase UID: ${firebaseUser.uid}');

      // Get user profile from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      String userName;
      String userRole = 'user';

      if (!docSnapshot.exists) {
        // Profile missing — create a basic one
        userName = firebaseUser.email?.split('@')[0] ?? 'User';
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'email': email.toLowerCase(),
          'name': userName,
          'role': 'user',
          'profileImageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      } else {
        final data = docSnapshot.data()!;
        userName = data['name'] as String;
        userRole = data['role'] as String? ?? 'user';

        // Update lastLoginAt timestamp
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .update({'lastLoginAt': FieldValue.serverTimestamp()});
      }

      final user = User(
        id: firebaseUser.uid,
        email: email.toLowerCase(),
        name: userName,
        role: userRole,
      );

      await _saveUserSession(user);
      print('=== SIGN IN SUCCESS ===');
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} — ${e.message}');
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw AuthException(e.message ?? 'Sign in failed.');
      }
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  /// Save user session to SharedPreferences
  Future<void> _saveUserSession(User user) async {
    try {
      _currentUser = user;
      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userKey, jsonEncode(user.toJson()));
      await _prefs.setString(
          _sessionTokenKey, 'session_${user.id}_${DateTime.now().millisecondsSinceEpoch}');
    } catch (e) {
      throw AuthException('Failed to save session: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      await _prefs.remove(_isLoggedInKey);
      await _prefs.remove(_userKey);
      await _prefs.remove(_sessionTokenKey);
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  /// Upload profile image to Firebase Storage
  Future<String> _uploadProfileImage(File imageFile) async {
    try {
      final userId = _currentUser!.id;
      final fileName = 'profile_images/$userId.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      // Upload the file
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw AuthException('Failed to upload profile image: $e');
    }
  }

  /// Update user profile (local + Firestore)
  Future<User> updateProfile({
    required String name,
    File? profileImageFile,
  }) async {
    if (_currentUser == null) {
      throw AuthException('No user logged in.');
    }

    try {
      String? profileImageUrl = _currentUser!.profileImageUrl;

      // Upload new profile image if provided
      if (profileImageFile != null) {
        profileImageUrl = await _uploadProfileImage(profileImageFile);
      }

      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        profileImageUrl: profileImageUrl,
      );

      // Update Firestore document
      await _firestore.collection('users').doc(_currentUser!.id).update({
        'name': name,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      });

      await _saveUserSession(updatedUser);
      return updatedUser;
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  /// Check if session is valid
  Future<bool> isSessionValid() async {
    try {
      final sessionToken = _prefs.getString(_sessionTokenKey);
      return sessionToken != null && _currentUser != null;
    } catch (e) {
      return false;
    }
  }
}
