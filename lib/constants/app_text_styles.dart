import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Reusable text styles for the FitFi app.
class AppTextStyles {
  AppTextStyles._();

  // ── Headings ───────────────────────────────────────────
  static TextStyle get heading1 => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading3 => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ── Step Counter ───────────────────────────────────────
  static TextStyle get stepCount => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get stepLabel => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.0,
        color: AppColors.textSecondary,
      );

  // ── Card Values ────────────────────────────────────────
  static TextStyle get cardValueLarge => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get cardValueLight => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnDark,
      );

  static TextStyle get cardLabel => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get cardLabelLight => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: AppColors.textMuted,
      );

  // ── Body ───────────────────────────────────────────────
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Greeting ───────────────────────────────────────────
  static TextStyle get greeting => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: AppColors.textSecondary,
      );

  // ── Navigation ─────────────────────────────────────────
  static TextStyle get navLabel => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      );

  // ── Buttons / Links ────────────────────────────────────
  static TextStyle get actionLink => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: AppColors.therapyText,
      );

  // ── Step Counter Screen ────────────────────────────────
  static TextStyle get stepScreenCount => GoogleFonts.outfit(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get stepScreenStatValue => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.stepGreen,
      );

  static TextStyle get stepScreenSectionTitle => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );
}
