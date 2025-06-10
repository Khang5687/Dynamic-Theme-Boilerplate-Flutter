import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../settings/app_settings.dart';

/// Main color accessor function - use this throughout your app
/// Example: getColor(context, "primary") or getColor(context, "textLight")
Color getColor(BuildContext context, String colorName) {
  return Theme.of(context).extension<AppColors>()?.colors[colorName] ??
      Colors.red; // Red indicates missing color for debugging
}

/// Creates theme-appropriate colors based on brightness and user settings
AppColors getAppColors({
  required Brightness brightness,
  required ThemeData themeData,
  required Color accentColor,
}) {
  // Determine if using Material You theming
  bool useMaterialYou = AppSettings.get<bool>('materialYou') ?? false;
  bool useSystemAccent = AppSettings.get<bool>('useSystemAccent') ?? false;
  bool increaseContrast = AppSettings.get<bool>('increaseTextContrast') ?? false;

  return brightness == Brightness.light
      ? AppColors(
          colors: {
            // Basic colors
            "white": Colors.white,
            "black": Colors.black,
            
            // Text colors
            "text": Colors.black,
            "textLight": increaseContrast
                ? Colors.black.withOpacity(0.7)
                : useMaterialYou
                    ? Colors.black.withOpacity(0.4)
                    : const Color(0xFF888888),
            "textSecondary": Colors.black.withOpacity(0.6),
            
            // Background colors
            "background": Colors.white,
            "surface": const Color(0xFFF7F7F7),
            "surfaceContainer": const Color(0xFFEBEBEB),
            "surfaceContainerHigh": const Color(0xFFE0E0E0),
            
            // Accent colors
            "primary": accentColor,
            "primaryLight": _lightenColor(accentColor, 0.3),
            "primaryDark": _darkenColor(accentColor, 0.2),
            
            // Semantic colors
            "success": const Color(0xFF59A849),
            "error": const Color(0xFFCA5A5A),
            "warning": const Color(0xFFCA995A),
            "info": const Color(0xFF58A4C2),
            
            // Border and divider colors
            "border": useMaterialYou
                ? const Color(0x0F000000)
                : const Color(0xFFF0F0F0),
            "divider": const Color(0xFFE0E0E0),
            
            // Shadow colors
            "shadow": const Color(0x655A5A5A),
            "shadowLight": const Color(0x2D5A5A5A),
            
            // Special purpose colors
            "overlay": Colors.black.withOpacity(0.5),
            "disabled": Colors.grey.shade400,
          },
        )
      : AppColors(
          colors: {
            // Basic colors (inverted for dark mode)
            "white": Colors.black,
            "black": Colors.white,
            
            // Text colors
            "text": Colors.white,
            "textLight": increaseContrast
                ? Colors.white.withOpacity(0.65)
                : useMaterialYou
                    ? Colors.white.withOpacity(0.25)
                    : const Color(0xFF494949),
            "textSecondary": Colors.white.withOpacity(0.6),
            
            // Background colors
            "background": const Color(0xFF121212),
            "surface": const Color(0xFF1E1E1E),
            "surfaceContainer": const Color(0xFF242424),
            "surfaceContainerHigh": const Color(0xFF2C2C2C),
            
            // Accent colors
            "primary": accentColor,
            "primaryLight": _lightenColor(accentColor, 0.2),
            "primaryDark": _darkenColor(accentColor, 0.3),
            
            // Semantic colors
            "success": const Color(0xFF62CA77),
            "error": const Color(0xFFDA7272),
            "warning": const Color(0xFFDA9C72),
            "info": const Color(0xFF7DB6CC),
            
            // Border and divider colors
            "border": useMaterialYou
                ? const Color(0x13FFFFFF)
                : const Color(0x6F363636),
            "divider": const Color(0xFF383838),
            
            // Shadow colors
            "shadow": const Color(0x69BDBDBD),
            "shadowLight": useMaterialYou
                ? Colors.transparent
                : const Color(0x28747474),
            
            // Special purpose colors
            "overlay": Colors.white.withOpacity(0.1),
            "disabled": Colors.grey.shade600,
          },
        );
}

/// Theme extension for custom colors
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.colors,
  });

  final Map<String, Color?> colors;

  @override
  AppColors copyWith({Map<String, Color?>? colors}) {
    return AppColors(
      colors: colors ?? this.colors,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    final Map<String, Color?> lerpColors = {};
    colors.forEach((key, value) {
      lerpColors[key] = Color.lerp(colors[key], other.colors[key], t);
    });

    return AppColors(
      colors: lerpColors,
    );
  }
}

/// Helper functions for color manipulation
Color _lightenColor(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

Color _darkenColor(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

/// Lighten color using alpha blending (pastel effect)
Color lightenPastel(Color color, {double amount = 0.1}) {
  return Color.alphaBlend(
    Colors.white.withOpacity(amount),
    color,
  );
}

/// Darken color using alpha blending
Color darkenPastel(Color color, {double amount = 0.1}) {
  return Color.alphaBlend(
    Colors.black.withOpacity(amount),
    color,
  );
}

/// Generate a dynamic pastel color based on context
Color dynamicPastel(
  BuildContext context,
  Color baseColor, {
  bool inverse = false,
  double amountLight = 0.2,
  double amountDark = 0.2,
}) {
  final brightness = Theme.of(context).brightness;
  final isDark = brightness == Brightness.dark;
  
  if (inverse) {
    return isDark 
        ? lightenPastel(baseColor, amount: amountDark)
        : darkenPastel(baseColor, amount: amountLight);
  } else {
    return isDark 
        ? darkenPastel(baseColor, amount: amountDark)
        : lightenPastel(baseColor, amount: amountLight);
  }
}

/// Utility class for hex color conversion
class HexColor extends Color {
  static int _getColorFromHex(String? hexColor, Color? defaultColor) {
    try {
      if (hexColor == null) {
        return defaultColor?.value ?? Colors.grey.value;
      }
      
      hexColor = hexColor.replaceAll("#", "");
      hexColor = hexColor.replaceAll("0x", "");
      
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return defaultColor?.value ?? Colors.grey.value;
    }
  }

  HexColor(final String? hexColor, {final Color? defaultColor})
      : super(_getColorFromHex(hexColor, defaultColor));
}

/// Convert color to hex string
String? toHexString(Color? color) {
  if (color == null) return null;
  String valueString = color.value.toRadixString(16);
  return "0x$valueString";
}

/// Predefined selectable colors for UI elements
List<Color> getSelectableColors() {
  return [
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.blue.shade400,
    Colors.purple.shade400,
    Colors.orange.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade500,
    Colors.brown.shade400,
    Colors.grey.shade400,
    Colors.cyan.shade400,
    Colors.deepPurple.shade400,
    Colors.deepOrange.shade400,
    Colors.yellow.shade400,
    Colors.blueGrey.shade400,
  ];
} 