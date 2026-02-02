import 'package:flutter/material.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/screens/sign_in.dart';
import 'package:mad_project/screens/sign_up.dart';
import 'package:mad_project/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization removed
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isSignedIn = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _handleSignIn() {
    setState(() => _isSignedIn = true);
  }

  void _handleSignOut() {
    setState(() => _isSignedIn = false);
  }

  void _navigateToSignUp() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(
          onSignUpSuccess: () {
            _navigatorKey.currentState?.pop();
            _handleSignIn();
          },
          onNavigateToSignIn: () => _navigatorKey.currentState?.pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _isSignedIn
          ? HomeScreen(
              onThemeToggle: _toggleTheme,
              onSignOut: _handleSignOut,
            )
          : SignInScreen(
              onSignInSuccess: _handleSignIn,
              onNavigateToSignUp: _navigateToSignUp,
            ),
    );
  }
}
