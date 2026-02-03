import 'package:shared_preferences/shared_preferences.dart';
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
      : super('Password is too weak. Use at least 8 characters with uppercase, lowercase, and numbers.');
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
  
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sessionTokenKey = 'session_token';
  
  // Mock database - in production, use Firebase or your backend
  static final Map<String, Map<String, String>> _mockUserDatabase = {
    'test@example.com': {
      'id': '1',
      'password': 'Test@1234', // In production, never store plain passwords!
      'name': 'Test User',
    },
  };

  /// Initialize the auth service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
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

  /// Validate password strength
  bool _isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Register a new user
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

      // Check if email already exists (simulate database check)
      if (_mockUserDatabase.containsKey(email.toLowerCase())) {
        throw EmailAlreadyInUseException();
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email.toLowerCase(),
        name: name,
      );

      // Save user details to database (simulated)
      _mockUserDatabase[email.toLowerCase()] = {
        'id': newUser.id,
        'password': password, // In production: hash the password!
        'name': name,
      };

      // Save to local storage
      await _saveUserSession(newUser);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || !_isValidEmail(email)) {
        throw InvalidEmailException();
      }

      if (password.isEmpty) {
        throw AuthException('Please enter your password.');
      }

      // Simulate network call
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if user exists
      final userData = _mockUserDatabase[email.toLowerCase()];
      if (userData == null) {
        throw UserNotFoundException();
      }

      // Check password (in production: use bcrypt or similar)
      if (userData['password'] != password) {
        throw WrongPasswordException();
      }

      // Create user object
      final user = User(
        id: userData['id']!,
        email: email.toLowerCase(),
        name: userData['name']!,
      );

      // Save session
      await _saveUserSession(user);

      return user;
    } catch (e) {
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
      // Simulate API call to invalidate token
      await Future.delayed(const Duration(milliseconds: 300));

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
}
