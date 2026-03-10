import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds (Light/Modern) ──────────────
  static const Color background = Color(
    0xFFFAF9F6,
  ); // Soft off-white (Alabaster)
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceLight = Color(0xFFF3F4F6); // subtle gray
  static const Color card = Color(0xFFFFFFFF);

  // ── Golden/Amber Accents ────────────────────
  static const Color gold = Color(0xFFD4AF37); // Classic elegant gold
  static const Color goldLight = Color(0xFFFDE68A); // Soft pastel gold
  static const Color amber = Color(0xFFF59E0B); // Strong amber/orange-yellow
  static const Color yellow = Color(0xFFEAB308); // Vivid yellow
  static const Color darkAccent = Color(
    0xFF111827,
  ); // Charcoal for high contrast

  // Old Aliases mapped to new theme to prevent build errors before updating other files
  static const Color violet =
      darkAccent; // Using dark contrast instead of purple
  static const Color violetLight = Color(0xFF374151);
  static const Color coral = amber;
  static const Color teal = gold;
  static const Color amberOld = yellow;
  static const Color green = Color(
    0xFF10B981,
  ); // Keep a green for 'current' badges
  static const Color pink = goldLight;
  static const Color orange = amber;

  // ── Text (Dark on light bg) ─────────────────
  static const Color textPrimary = Color(0xFF111827); // Very dark gray/charcoal
  static const Color textSecondary = Color(0xFF4B5563); // Medium gray
  static const Color textMuted = Color(0xFF9CA3AF); // Light gray

  // ── Borders ─────────────────────────────────
  static const Color border = Color(0xFFE5E7EB); // Very soft gray
  static const Color borderLight = Color(0xFFF3F4F6);

  // ── Shadows ─────────────────────────────────
  static const Color shadow = Color(0x0A000000); // 4% black shadow

  // ── Gradients ───────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gold, amber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [gold, amber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Remapping old gradients
  static const LinearGradient tealGradient = primaryGradient;
  static const LinearGradient coralGradient = primaryGradient;
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x15D4AF37), Colors.transparent], // Gold glow
    radius: 0.8,
  );
}
