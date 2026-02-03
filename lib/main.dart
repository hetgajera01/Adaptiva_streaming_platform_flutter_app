import 'package:flutter/material.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/screens/sign_in.dart';
import 'package:mad_project/screens/sign_up.dart';
import 'package:mad_project/screens/home.dart';
import 'package:mad_project/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize auth service
  final authService = AuthService();
  await authService.initialize();
  
  runApp(MyApp(authService: authService));
}

class MyApp extends StatefulWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    setState(() {
      _isSignedIn = widget.authService.isLoggedIn;
    });
  }

  void _handleSignIn() {
    setState(() => _isSignedIn = true);
  }

  void _handleSignOut() {
    widget.authService.signOut().then((_) {
      setState(() => _isSignedIn = false);
      _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SignInScreen(
            authService: widget.authService,
            onSignInSuccess: _handleSignIn,
            onNavigateToSignUp: _navigateToSignUp,
          ),
        ),
        (route) => false,
      );
    });
  }

  void _navigateToSignUp() {
    _navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(
          authService: widget.authService,
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
      themeMode: ThemeMode.light,
      home: _isSignedIn
          ? HomeScreen(
              onSignOut: _handleSignOut,
            )
          : SignInScreen(
              authService: widget.authService,
              onSignInSuccess: _handleSignIn,
              onNavigateToSignUp: _navigateToSignUp,
            ),
    );
  }
}
