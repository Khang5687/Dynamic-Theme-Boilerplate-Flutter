import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../settings/app_settings.dart';

/// Material You integration for dynamic theming
class MaterialYouManager {
  static ColorScheme? _lightDynamic;
  static ColorScheme? _darkDynamic;
  static bool _initialized = false;

  /// Initialize Material You colors from system
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Get dynamic colors from system (Android 12+ or supported platforms)
      final corePalette = await DynamicColorPlugin.getCorePalette();
      
      if (corePalette != null) {
        _lightDynamic = corePalette.toColorScheme(brightness: Brightness.light);
        _darkDynamic = corePalette.toColorScheme(brightness: Brightness.dark);
        
        debugPrint('Material You: Dynamic colors loaded successfully');
      }
    } catch (e) {
      debugPrint('Material You initialization failed: $e');
    }
    
    _initialized = true;
  }

  /// Check if Material You is supported on current platform
  static bool isSupported() {
    if (kIsWeb) return false;
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Material You is supported on Android 12+ (API 31+)
        // We'll allow it even if dynamic colors aren't available yet
        return true;
      case TargetPlatform.iOS:
        // iOS doesn't have Material You but can use system accent colors
        return false;
      default:
        return false;
    }
  }

  /// Check if dynamic colors are actually available
  static bool hasDynamicColors() {
    return _lightDynamic != null && _darkDynamic != null;
  }

  /// Check if Material You is enabled in settings
  static bool isEnabled() {
    return AppSettings.getWithDefault<bool>('materialYou', false) && isSupported();
  }

  /// Check if Material You is enabled AND has dynamic colors
  static bool isEnabledWithDynamicColors() {
    return isEnabled() && hasDynamicColors();
  }

  /// Get dynamic color scheme for the given brightness
  static ColorScheme? getDynamicColorScheme(Brightness brightness) {
    if (!isEnabledWithDynamicColors()) return null;
    
    return brightness == Brightness.light ? _lightDynamic : _darkDynamic;
  }

  /// Get system accent color or fallback
  static Color getSystemAccentColor() {
    if (isEnabledWithDynamicColors()) {
      return _lightDynamic!.primary;
    }
    
    // Fallback to user-selected accent color
    return AppSettings.accentColor;
  }

  /// Check if system accent should be used
  static bool shouldUseSystemAccent() {
    return AppSettings.getWithDefault<bool>('useSystemAccent', false) && 
           isSupported();
  }

  /// Get platform-appropriate accent color
  static Color getAccentColor() {
    if (shouldUseSystemAccent()) {
      return getSystemAccentColor();
    }
    return AppSettings.accentColor;
  }

  /// Create ColorScheme with Material You integration
  static ColorScheme createColorScheme({
    required Brightness brightness,
    Color? fallbackSeedColor,
  }) {
    // Try to get dynamic color scheme first
    final dynamicScheme = getDynamicColorScheme(brightness);
    if (dynamicScheme != null) {
      return dynamicScheme;
    }

    // Fallback to seed-based color scheme
    final seedColor = fallbackSeedColor ?? getAccentColor();
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
  }

  /// Generate theme-aware surfaces for Material You
  static Color getSurfaceColor(BuildContext context, {
    Color? fallbackColor,
    double elevation = 0,
  }) {
    if (isEnabledWithDynamicColors()) {
      final colorScheme = Theme.of(context).colorScheme;
      
      // Use Material You surface tones based on elevation
      if (elevation == 0) return colorScheme.surface;
      if (elevation <= 1) return colorScheme.surfaceVariant;
      if (elevation <= 3) return colorScheme.surfaceContainerLow;
      if (elevation <= 6) return colorScheme.surfaceContainer;
      return colorScheme.surfaceContainerHigh;
    }
    
    return fallbackColor ?? Theme.of(context).colorScheme.surface;
  }

  /// Check if current platform supports system colors
  static bool supportsPlatformColors() {
    if (kIsWeb) return false;
    
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return true; // Android 12+ supports Material You
      case TargetPlatform.iOS:
        return true; // iOS supports system accent colors
      case TargetPlatform.macOS:
        return true; // macOS supports system accent colors
      default:
        return false;
    }
  }

  /// Get platform name for display
  static String getPlatformName() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      default:
        return 'Unknown';
    }
  }

  /// Reset Material You colors (useful for debugging)
  static void reset() {
    _lightDynamic = null;
    _darkDynamic = null;
    _initialized = false;
  }

  /// Get a user-friendly status message
  static String getStatusMessage() {
    if (!isSupported()) {
      return 'Not supported on ${getPlatformName()}';
    }
    
    if (!_initialized) {
      return 'Initializing...';
    }
    
    if (!hasDynamicColors()) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return 'Requires Android 12+ with dynamic colors enabled';
      }
      return 'Dynamic colors not available';
    }
    
    return isEnabled() ? 'Active with dynamic colors' : 'Available but disabled';
  }

  /// Debug info about Material You status
  static Map<String, dynamic> getDebugInfo() {
    return {
      'platform': getPlatformName(),
      'isSupported': isSupported(),
      'isEnabled': isEnabled(),
      'hasDynamicColors': hasDynamicColors(),
      'isEnabledWithDynamicColors': isEnabledWithDynamicColors(),
      'hasLightDynamic': _lightDynamic != null,
      'hasDarkDynamic': _darkDynamic != null,
      'useSystemAccent': shouldUseSystemAccent(),
      'systemAccentColor': getSystemAccentColor().toString(),
      'fallbackAccentColor': AppSettings.accentColor.toString(),
      'statusMessage': getStatusMessage(),
    };
  }
} 