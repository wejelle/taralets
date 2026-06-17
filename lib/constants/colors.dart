import 'package:flutter/material.dart';

abstract class AppColors {
  // Base surfaces
  static const Color background = Color(0xFFF4F6F9);
  static const Color surface = Colors.white;

  // Typography
  static const Color charcoal = Color(0xFF1E293B);
  static const Color bodyText = Color(0xFF475569);
  static const Color captionText = Color(0xFF94A3B8);

  // Primary action
  static const Color primary = Color(0xFF0066FF);
  static const Color primaryLight = Color(0xFFE0ECFF);

  // Dynamic status
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFCCFBF1);

  // Urgency / warning
  static const Color urgent = Color(0xFFEA580C);
  static const Color urgentLight = Color(0xFFFFEDD5);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEE2E2);

  // Neutral
  static const Color divider = Color(0xFFE2E8F0);
  static const Color cardBorder = Color(0xFFF1F5F9);
  static const Color starGold = Color(0xFFF59E0B);
}
