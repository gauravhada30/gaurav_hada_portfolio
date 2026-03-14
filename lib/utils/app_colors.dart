import 'package:flutter/material.dart';

class AppColors {
  // ── Dark Backgrounds ────────────────────────────
  static const Color background = Color(0xFF0A0A0F);   // Deep dark near-black
  static const Color surface = Color(0xFF12121A);       // Elevated dark surface
  static const Color surfaceLight = Color(0xFF1A1A26); // Card surface
  static const Color card = Color(0xFF1E1E2E);          // Card bg
  static const Color cardHover = Color(0xFF252538);     // Card hover state

  // ── Gold/Amber Accents ──────────────────────────
  static const Color gold = Color(0xFFD4AF37);          // Classic elegant gold
  static const Color goldLight = Color(0xFFFFD700);     // Bright gold
  static const Color amber = Color(0xFFF59E0B);         // Strong amber
  static const Color yellow = Color(0xFFEAB308);        // Vivid yellow
  static const Color darkAccent = Color(0xFFD4AF37);    // Use gold as CTA

  // ── Aliases ─────────────────────────────────────
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetLight = Color(0xFF8B5CF6);
  static const Color coral = amber;
  static const Color teal = gold;
  static const Color amberOld = yellow;
  static const Color green = Color(0xFF10B981);
  static const Color pink = Color(0xFFEC4899);
  static const Color orange = amber;

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF1F1F3);   // Off-white
  static const Color textSecondary = Color(0xFF9CA3AF); // Muted gray
  static const Color textMuted = Color(0xFF4B5563);     // Very muted

  // ── Borders ──────────────────────────────────────
  static const Color border = Color(0xFF2A2A3E);        // Subtle dark border
  static const Color borderLight = Color(0xFF1E1E30);   // Even subtler
  static const Color borderGold = Color(0x33D4AF37);    // Gold border at 20%

  // ── Shadows ──────────────────────────────────────
  static const Color shadow = Color(0x40000000);

  // ── Gradients ────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gold, amber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = primaryGradient;
  static const LinearGradient coralGradient = primaryGradient;

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF12121A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF12121A), Color(0xFF1A1A26)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient glowGradient = RadialGradient(
    colors: [Color(0x25D4AF37), Colors.transparent],
    radius: 0.8,
  );

  // ── Special Decorations ──────────────────────────
  static BoxDecoration get glassCard => BoxDecoration(
    color: const Color(0xFF1A1A26).withAlpha(200),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: border, width: 1),
  );

  static BoxDecoration get glassCardHover => BoxDecoration(
    color: const Color(0xFF1E1E2E).withAlpha(240),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: borderGold, width: 1),
  );
}
