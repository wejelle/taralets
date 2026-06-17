import 'package:flutter/material.dart';

class AppColors {
  // ── Main Theme Colors ──────────────────────────────────────────
  static const Color primary = Color.fromARGB(255, 255, 15, 71); // Pinkish Red
  static const Color secondary =
      Color(0xFFF89B29); // Orange (Para sa kabilang dulo ng gradient)
  static const Color peach =
      Color(0xFFFF8A7A); // BAGO: Gitna ng gradient para smooth ang flow
  static const Color primaryLight =
      Color(0xFFFFE5EE); // Lighter shade ng primary para sa highlights
  static const Color background =
      Color(0xFFFAFAFA); // Clean off-white background
  static const Color surface =
      Color(0xFFF8FAFC); // Light gray para sa cards/fields

  // ── Text & UI Elements ─────────────────────────────────────────
  static const Color charcoal =
      Color(0xFF1E293B); // Dark blue-gray para sa readable text
  static const Color bodyText = Color(0xFF475569); // Medium text
  static const Color captionText =
      Color(0xFF94A3B8); // Faded text para sa subtitles
  static const Color divider = Color(0xFFE2E8F0); // Lines at borders
  static const Color cardBorder =
      Color(0xFFF1F5F9); // Subtle borders para sa cards

  // ── Status Colors ──────────────────────────────────────────────
  static const Color teal = Color(0xFF10B981); // Success / Sabay-sabay status
  static const Color tealLight = Color(0xFFD1FAE5);
  static const Color danger = Color(0xFFEF4444); // Errors
  static const Color dangerLight = Color(0xFFFEE2E2);
  static const Color urgent =
      Color(0xFFF59E0B); // Priority alerts (Far participants)
  static const Color urgentLight = Color(0xFFFEF3C7);
  static const Color starGold =
      Color(0xFFFFB800); // Bright Gold para sa Star Ratings

  // ── Global Aesthetic Background Gradient ──────────────────
  static const Gradient globalThemeGradient = LinearGradient(
    colors: [
      Color(0xFFFFEAEE), // Faint Hot Pink tint
      Color(0xFFFFF2E6), // Faint Peach tint
      Color(0xFFFFF9F2), // Faint Soft Orange tint
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
