import 'package:flutter/material.dart';

class ColorPalette {
  // ===== True Color Shade Definitions =====
  static const Color emeraldGreen = Color(0xFF023A22);
  static const Color darkForestGreen = Color(0xFF012415);
  static const Color forestGreenHover = Color(0xFF0B5C3B);
  static const Color paleMint = Color(0xFFF0F7F3);
  static const Color softSage = Color(0xFFABC8A3);
  static const Color paleSage = Color(0xFFDCEBE1);
  static const Color goldHighlight = Color(0xFFF0E295);
  static const Color oceanBlue = Color(0xFF28729F);
  static const Color crimsonRed = Color(0xFFB94C4C);
  static const Color darkCharcoal = Color(0xFF151C15);
  static const Color mutedSlate = Color(0xFF556355);
  static const Color lightGray = Color(0xFF98A399);

  // ===== Primary & Brand Semantics =====
  static const Color primary = emeraldGreen;
  static const Color primaryHover = forestGreenHover;
  static const Color primaryPressed = darkForestGreen;
  static const Color primarySoftBackground = paleMint;

  static const Color secondary = oceanBlue;
  static const Color accent = softSage;
  static const Color highlight = goldHighlight;
  static const Color navActiveGlow = Color(0xFF94D041);
  static const Color navActiveText = Color(0xFFC6E762);

  // ===== Background & Surface =====
  static const Color background = paleMint;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ===== Border & Divider =====
  static const Color border = Color(0xFFDDE3DF);
  static const Color divider = Color(0xFFEEF1EF);

  // ===== Text Color Tokens =====
  static const Color textPrimary = darkCharcoal;
  static const Color textSecondary = mutedSlate;
  static const Color textMuted = lightGray;
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHighLight = goldHighlight;
  static const Color textSoftSaga = softSage;
  static const Color textBlack = Color(0xFF000000);
  static const Color textOceanBlue = oceanBlue;
  static const Color textRed = crimsonRed;

  // ===== State Colors ====
  static const Color disabled = Color(0xFFC2CAC4);
  static const Color success = forestGreenHover;
  static const Color warning = Color(0xFFB8860B);
  static const Color error = Color(0xFFC0392B);
  static const Color info = oceanBlue;
}
