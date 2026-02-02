import 'package:flutter/material.dart';
import 'package:mad_project/config/constants.dart';
import 'package:mad_project/config/theme.dart';

/// Reusable custom card widget
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final Color backgroundColor;
  final Color shadowColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final BorderSide? borderSide;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.spacingMedium),
    this.margin = const EdgeInsets.all(AppConstants.spacingSmall),
    this.elevation = 2,
    this.backgroundColor = AppTheme.surfaceColor,
    this.shadowColor = AppTheme.shadowColor,
    this.borderRadius = AppConstants.radiusLarge,
    this.onTap,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: elevation,
        shadowColor: shadowColor,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Feature card widget for dashboard
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        elevation: 3,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // Title
            Text(
              title,
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              description,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
