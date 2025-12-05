import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Özelleştirilebilir uygulama kartı
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final double borderRadius;
  final bool hasBorder;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 16,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null
            ? (backgroundColor ?? AppColors.cardBackground)
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: AppColors.cardBorder, width: 1)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: cardContent,
          ),
        ),
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: cardContent,
    );
  }
}

/// Gradient kenarlıklı kart
class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final LinearGradient gradient;
  final double borderRadius;
  final double borderWidth;

  const GradientBorderCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.gradient = AppColors.primaryGradient,
    this.borderRadius = 16,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          margin: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
