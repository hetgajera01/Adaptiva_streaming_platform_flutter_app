import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:convert';

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

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
  });

  /// Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
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
  late DatabaseReference _database;
  late firebase_auth.FirebaseAuth _auth;
  
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sessionTokenKey = 'session_token';

  /// Initialize the auth service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _database = FirebaseDatabase.instance.ref();
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

  /// Get current user
  User? get currentUser => _currentUser;

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength (basic check, Firebase will enforce its own rules)
  bool _isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  /// Register a new user with Firebase Authentication
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Validate inputs
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

      // Save user profile data to Realtime Database (NOT password)
      await _database.child('users').child(firebaseUser.uid).set({
        'id': firebaseUser.uid,
        'email': email.toLowerCase(),
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Save to local storage
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

  /// Sign in with Firebase Authentication
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('=== SIGN IN START ===');
      print('Email: $email');
      
      // Validate inputs
      if (email.isEmpty || !_isValidEmail(email)) {
        print('Invalid email format');
        throw InvalidEmailException();
      }

      if (password.isEmpty) {
        print('Password is empty');
        throw AuthException('Please enter your password.');
      }

      print('Calling Firebase signInWithEmailAndPassword...');
      
      // Sign in with Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      print('Firebase authentication successful');
      
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        print('Firebase user is null');
        throw AuthException('Sign in failed.');
      }

      print('Firebase UID: ${firebaseUser.uid}');
      print('Checking Realtime Database for user profile...');
      
      // Get user profile data from Realtime Database
      final snapshot = await _database.child('users').child(firebaseUser.uid).get();
      
      String userName;
      
      if (!snapshot.exists) {
        print('User profile not found in database, creating new profile...');
        // User exists in Firebase Auth but not in Realtime Database
        // This can happen if the user was created directly in Firebase Console
        // or if there was an issue during registration
        // Create a basic profile for them
        userName = firebaseUser.email?.split('@')[0] ?? 'User';
        
        print('Creating profile with username: $userName');
        
        await _database.child('users').child(firebaseUser.uid).set({
          'id': firebaseUser.uid,
          'email': email.toLowerCase(),
          'name': userName,
          'createdAt': DateTime.now().toIso8601String(),
        });
        
        print('Profile created successfully');
      } else {
        print('User profile found in database');
        final userData = Map<String, dynamic>.from(snapshot.value as Map);
        userName = userData['name'] as String;
        print('Username: $userName');
      }

      // Create user object
      final user = User(
        id: firebaseUser.uid,
        email: email.toLowerCase(),
        name: userName,
      );

      print('Saving user session...');
      
      // Save session
      await _saveUserSession(user);

      print('=== SIGN IN SUCCESS ===');
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException caught: ${e.code}');
      print('Message: ${e.message}');
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
      print('Unexpected error caught: $e');
      print('Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  /// Save user session to SharedPreferences
  Future<void> _saveUserSession(User user) async {
    try {
      _currentUser = user;
      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userKey, jsonEncode(user.toJson()));
      // In production, generate and store actual JWT token
      await _prefs.setString(_sessionTokenKey, 'session_${user.id}_${DateTime.now().millisecondsSinceEpoch}');
    } catch (e) {
      throw AuthException('Failed to save session: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Clear session data
      _currentUser = null;
      await _prefs.remove(_isLoggedInKey);
      await _prefs.remove(_userKey);
      await _prefs.remove(_sessionTokenKey);
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  /// Update user profile
  Future<User> updateProfile({
    required String name,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      throw AuthException('No user logged in.');
    }

    try {
      final updatedUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name,
        profileImageUrl: profileImageUrl,
      );

      await _saveUserSession(updatedUser);
      return updatedUser;
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  /// Check if session is valid (can be extended with token validation)
  Future<bool> isSessionValid() async {
    try {
      final sessionToken = _prefs.getString(_sessionTokenKey);
      return sessionToken != null && _currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to sanitize email for use as Firebase key
  /// Firebase keys cannot contain: . $ # [ ] /
  String _sanitizeEmail(String email) {
    return email.toLowerCase().replaceAll('.', ',');
  }
}
