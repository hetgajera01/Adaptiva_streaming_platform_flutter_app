import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';
import 'package:mad_project/widgets/custom_button.dart';
import 'package:mad_project/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSignUpSuccess;
  final VoidCallback onNavigateToSignIn;

  const SignUpScreen({
    super.key,
    required this.onSignUpSuccess,
    required this.onNavigateToSignIn,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(AppConstants.animationSlow, () {
        if (mounted) {
          setState(() => _isLoading = false);
          widget.onSignUpSuccess();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? AppConstants.spacingMedium
                    : AppConstants.spacingXLarge,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: isMobile
                            ? AppConstants.spacingLarge
                            : AppConstants.spacingXXLarge,
                      ),

                      // App Logo
                      _buildLogo(),

                      SizedBox(
                        height: isMobile
                            ? AppConstants.spacingXLarge
                            : AppConstants.spacingXXLarge,
                      ),

                      // White Card Container
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusXLarge,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowColor,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(
                          isMobile
                              ? AppConstants.spacingLarge
                              : AppConstants.spacingXLarge,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title removed as per requirement

                              SizedBox(
                                height: AppConstants.spacingXLarge,
                              ),

                              // Name Field
                              CustomTextField(
                                label: 'Full Name',
                                hint: 'Enter your full name',
                                controller: _nameController,
                                prefixIcon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: AppConstants.spacingLarge,
                              ),

                              // Email Field
                              CustomTextField(
                                label: 'Email Address',
                                hint: 'Enter your email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: AppConstants.spacingLarge,
                              ),

                              // Password Field
                              CustomTextField(
                                label: 'Password',
                                hint: 'Create a password',
                                controller: _passwordController,
                                obscureText: true,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: Icons.visibility_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: AppConstants.spacingLarge,
                              ),

                              // Confirm Password Field
                              CustomTextField(
                                label: 'Confirm Password',
                                hint: 'Re-enter your password',
                                controller: _confirmController,
                                obscureText: true,
                                prefixIcon: Icons.lock_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: AppConstants.spacingXLarge,
                              ),

                              // Sign Up Button
                              CustomButton(
                                label: 'Create Account',
                                onPressed: _handleSignUp,
                                isLoading: _isLoading,
                                icon: Icons.person_add_alt_1,
                              ),

                              SizedBox(
                                height: AppConstants.spacingLarge,
                              ),

                              // Already have account
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onNavigateToSignIn,
                                    child: Text(
                                      'Sign In',
                                      style: AppTheme.bodyMedium.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: isMobile
                            ? AppConstants.spacingLarge
                            : AppConstants.spacingXLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CustomPaint(
            painter: LogoPainter(),
            size: const Size(45, 45),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Text(
          'Sign up',
          style: AppTheme.headlineLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redCirclePaint = Paint()
      ..color = const Color(0xFFFF4757)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw red circle background (full size)
    canvas.drawCircle(center, size.width * 0.5, redCirclePaint);

    // Draw white head (circle) - proportionate
    final headRadius = size.width * 0.11;
    final headCenter = Offset(size.width / 2, size.height * 0.30);
    canvas.drawCircle(headCenter, headRadius, whitePaint);

    // Draw white shoulders/body - simplified and clean
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.18, size.height * 0.48);
    bodyPath.quadraticBezierTo(
      size.width / 2,
      size.height * 0.58,
      size.width * 0.82,
      size.height * 0.48,
    );
    bodyPath.lineTo(size.width * 0.82, size.height * 0.72);
    bodyPath.lineTo(size.width * 0.18, size.height * 0.72);
    bodyPath.close();
    canvas.drawPath(bodyPath, whitePaint);
  }

  @override
  bool shouldRepaint(LogoPainter oldDelegate) => false;
}
