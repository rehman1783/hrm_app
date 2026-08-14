import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class AppPlaceholderPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? body;
  final Widget? drawer;

  const AppPlaceholderPage({
    super.key,
    required this.title,
    this.subtitle,
    this.body,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColors = theme.brightness == Brightness.dark
        ? [theme.scaffoldBackgroundColor, theme.colorScheme.surface]
        : [theme.colorScheme.surface, theme.scaffoldBackgroundColor];

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(title: Text(title)),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1.0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.76),
                        ),
                      ),
                    ],
                    if (body != null) ...[const SizedBox(height: 22), body!],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
