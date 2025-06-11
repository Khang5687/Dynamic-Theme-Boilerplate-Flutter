import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/app_settings.dart';

/// iOS-specific theme integration
class IOSTheme {
  /// Create iOS-style Cupertino theme
  static CupertinoThemeData createCupertinoTheme({
    required Brightness brightness,
    Color? accentColor,
  }) {
    final accent = accentColor ?? AppSettings.accentColor;
    
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: accent,
      primaryContrastingColor: brightness == Brightness.light 
          ? CupertinoColors.white 
          : CupertinoColors.black,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? CupertinoColors.systemGroupedBackground
          : CupertinoColors.darkBackgroundGray,
      barBackgroundColor: brightness == Brightness.light
          ? CupertinoColors.systemBackground
          : const Color(0xFF1C1C1E),
      textTheme: CupertinoTextThemeData(
        primaryColor: brightness == Brightness.light
            ? CupertinoColors.label
            : CupertinoColors.white,
        textStyle: TextStyle(
          fontFamily: _getIOSFontFamily(),
          fontSize: 17,
          color: brightness == Brightness.light
              ? CupertinoColors.label
              : CupertinoColors.white,
        ),
      ),
    );
  }

  /// Get iOS system font family
  static String _getIOSFontFamily() {
    final fontFamily = AppSettings.getWithDefault<String>('fontFamily', 'Avenir');
    
    // iOS font mapping for better compatibility
    switch (fontFamily) {
      case 'SF Pro':
      case 'San Francisco':
        return '.SF UI Text'; // iOS system font
      case 'Avenir':
        return 'Avenir'; // Available on iOS
      case 'Helvetica':
        return 'Helvetica Neue'; // iOS version
      case 'DMSans':
        return 'DM Sans'; // Fallback to system font if not available
      case 'Inter':
        return 'Inter'; // Should work if font is included
      default:
        return '.SF UI Text'; // iOS system font fallback
    }
  }

  /// Create iOS-style colors that work with Material theme
  static MaterialColor createIOSMaterialColor(Color color) {
    return MaterialColor(
      color.value,
      <int, Color>{
        50: _tintColor(color, 0.9),
        100: _tintColor(color, 0.8),
        200: _tintColor(color, 0.6),
        300: _tintColor(color, 0.4),
        400: _tintColor(color, 0.2),
        500: color,
        600: _shadeColor(color, 0.1),
        700: _shadeColor(color, 0.2),
        800: _shadeColor(color, 0.3),
        900: _shadeColor(color, 0.4),
      },
    );
  }

  /// Tint a color (make it lighter)
  static Color _tintColor(Color color, double factor) {
    return Color.fromRGBO(
      color.red + ((255 - color.red) * factor).round(),
      color.green + ((255 - color.green) * factor).round(),
      color.blue + ((255 - color.blue) * factor).round(),
      1,
    );
  }

  /// Shade a color (make it darker)
  static Color _shadeColor(Color color, double factor) {
    return Color.fromRGBO(
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
      1,
    );
  }

  /// Check if current platform is iOS
  static bool isIOS() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Get iOS system colors based on brightness
  static Map<String, Color> getIOSSystemColors(Brightness brightness) {
    if (brightness == Brightness.light) {
      return {
        'label': const Color(0xFF000000),
        'secondaryLabel': const Color(0x993C3C43),
        'tertiaryLabel': const Color(0x4C3C3C43),
        'quaternaryLabel': const Color(0x2E3C3C43),
        'systemFill': const Color(0x33787880),
        'secondarySystemFill': const Color(0x28787880),
        'tertiarySystemFill': const Color(0x1E767680),
        'quaternarySystemFill': const Color(0x14747480),
        'placeholderText': const Color(0x4C3C3C43),
        'systemBackground': const Color(0xFFFFFFFF),
        'secondarySystemBackground': const Color(0xFFF2F2F7),
        'tertiarySystemBackground': const Color(0xFFFFFFFF),
        'systemGroupedBackground': const Color(0xFFF2F2F7),
        'secondarySystemGroupedBackground': const Color(0xFFFFFFFF),
        'tertiarySystemGroupedBackground': const Color(0xFFF2F2F7),
        'separator': const Color(0x493C3C43),
        'opaqueSeparator': const Color(0xFFC6C6C8),
        'link': const Color(0xFF007AFF),
        'systemBlue': const Color(0xFF007AFF),
        'systemPurple': const Color(0xFFAF52DE),
        'systemGreen': const Color(0xFF34C759),
        'systemYellow': const Color(0xFFFFCC00),
        'systemOrange': const Color(0xFFFF9500),
        'systemPink': const Color(0xFFFF2D92),
        'systemRed': const Color(0xFFFF3B30),
        'systemTeal': const Color(0xFF5AC8FA),
        'systemIndigo': const Color(0xFF5856D6),
        'systemBrown': const Color(0xFFA2845E),
        'systemMint': const Color(0xFF00C7BE),
        'systemCyan': const Color(0xFF32D2FF),
        'systemGray': const Color(0xFF8E8E93),
        'systemGray2': const Color(0xFFAEAEB2),
        'systemGray3': const Color(0xFFC7C7CC),
        'systemGray4': const Color(0xFFD1D1D6),
        'systemGray5': const Color(0xFFE5E5EA),
        'systemGray6': const Color(0xFFF2F2F7),
      };
    } else {
      return {
        'label': const Color(0xFFFFFFFF),
        'secondaryLabel': const Color(0x99EBEBF5),
        'tertiaryLabel': const Color(0x4CEBEBF5),
        'quaternaryLabel': const Color(0x28EBEBF5),
        'systemFill': const Color(0x33787880),
        'secondarySystemFill': const Color(0x28787880),
        'tertiarySystemFill': const Color(0x1E767680),
        'quaternarySystemFill': const Color(0x14747480),
        'placeholderText': const Color(0x4CEBEBF5),
        'systemBackground': const Color(0xFF000000),
        'secondarySystemBackground': const Color(0xFF1C1C1E),
        'tertiarySystemBackground': const Color(0xFF2C2C2E),
        'systemGroupedBackground': const Color(0xFF000000),
        'secondarySystemGroupedBackground': const Color(0xFF1C1C1E),
        'tertiarySystemGroupedBackground': const Color(0xFF2C2C2E),
        'separator': const Color(0x99545458),
        'opaqueSeparator': const Color(0xFF38383A),
        'link': const Color(0xFF0A84FF),
        'systemBlue': const Color(0xFF0A84FF),
        'systemPurple': const Color(0xFFBF5AF2),
        'systemGreen': const Color(0xFF30D158),
        'systemYellow': const Color(0xFFFFD60A),
        'systemOrange': const Color(0xFFFF9F0A),
        'systemPink': const Color(0xFFFF375F),
        'systemRed': const Color(0xFFFF453A),
        'systemTeal': const Color(0xFF64D2FF),
        'systemIndigo': const Color(0xFF5E5CE6),
        'systemBrown': const Color(0xFFAC8E68),
        'systemMint': const Color(0xFF63E6E2),
        'systemCyan': const Color(0xFF66D9EF),
        'systemGray': const Color(0xFF8E8E93),
        'systemGray2': const Color(0xFF636366),
        'systemGray3': const Color(0xFF48484A),
        'systemGray4': const Color(0xFF3A3A3C),
        'systemGray5': const Color(0xFF2C2C2E),
        'systemGray6': const Color(0xFF1C1C1E),
      };
    }
  }

  /// Create adaptive widget that uses iOS styles on iOS and Material on other platforms
  static Widget adaptiveButton({
    required VoidCallback onPressed,
    required Widget child,
    bool isPrimary = false,
    Color? color,
  }) {
    if (isIOS()) {
      return CupertinoButton(
        onPressed: onPressed,
        color: isPrimary ? (color ?? CupertinoColors.activeBlue) : null,
        child: child,
      );
    } else {
      return isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: color != null
                  ? ElevatedButton.styleFrom(backgroundColor: color)
                  : null,
              child: child,
            )
          : TextButton(
              onPressed: onPressed,
              child: child,
            );
    }
  }

  /// Create adaptive app bar
  static PreferredSizeWidget adaptiveAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    if (isIOS()) {
      return CupertinoNavigationBar(
        middle: Text(title),
        trailing: actions?.isNotEmpty == true
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    } else {
      return AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
  }

  /// Create adaptive scaffold
  static Widget adaptiveScaffold({
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
  }) {
    if (isIOS()) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        backgroundColor: backgroundColor,
        child: SafeArea(child: body),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
      );
    }
  }

  /// Get platform-appropriate haptic feedback
  static void hapticFeedback([HapticFeedbackType type = HapticFeedbackType.light]) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
}

enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
} 