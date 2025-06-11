import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global app settings manager based on the budget app's system
class AppSettings {
  static Map<String, dynamic> _settings = {};
  static SharedPreferences? _prefs;
  
  /// Initialize the settings system - call this in main()
  static Future<bool> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
    return true;
  }

  /// Get a setting value with type safety
  static T? get<T>(String key) {
    return _settings[key] as T?;
  }

  /// Get a setting value with a default fallback
  static T getWithDefault<T>(String key, T defaultValue) {
    return _settings[key] as T? ?? defaultValue;
  }

  /// Update a setting and persist it
  static Future<bool> set(String key, dynamic value, {
    bool notifyListeners = true,
  }) async {
    bool isChanged = _settings[key] != value;
    _settings[key] = value;
    
    await _saveSettings();
    
    if (isChanged && notifyListeners) {
      // Trigger app rebuild for theme changes
      _notifyAppStateChange();
    }
    
    return true;
  }

  /// Get all settings
  static Map<String, dynamic> getAll() {
    return Map<String, dynamic>.from(_settings);
  }

  /// Reset to default settings
  static Future<void> resetToDefaults() async {
    _settings = _getDefaultSettings();
    await _saveSettings();
    _notifyAppStateChange();
  }

  /// Load settings from persistent storage
  static Future<void> _loadSettings() async {
    try {
      final settingsJson = _prefs?.getString('app_settings');
      if (settingsJson != null) {
        final loadedSettings = json.decode(settingsJson) as Map<String, dynamic>;
        _settings = _mergeWithDefaults(loadedSettings);
      } else {
        _settings = _getDefaultSettings();
      }
    } catch (e) {
      print('Error loading settings: $e');
      _settings = _getDefaultSettings();
    }
  }

  /// Save settings to persistent storage
  static Future<void> _saveSettings() async {
    try {
      final settingsJson = json.encode(_settings);
      await _prefs?.setString('app_settings', settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  /// Merge loaded settings with defaults to handle new settings
  static Map<String, dynamic> _mergeWithDefaults(Map<String, dynamic> loaded) {
    final defaults = _getDefaultSettings();
    final merged = Map<String, dynamic>.from(defaults);
    
    loaded.forEach((key, value) {
      merged[key] = value;
    });
    
    return merged;
  }

  /// Default settings - customize these for your app
  static Map<String, dynamic> _getDefaultSettings() {
    return {
      // Theme settings
      'themeMode': 'system', // 'light', 'dark', 'system'
      'materialYou': false,   // User can enable if supported
      'useSystemAccent': false, // User can enable if supported
      'accentColor': '0xFF2196F3', // Default blue fallback
      
      // Text settings
      'font': 'Avenir', // 'system', 'Avenir', 'Inter', 'DMSans', etc.
      'fontSize': 16.0,
      'increaseTextContrast': false,
      
      // Localization
      'locale': 'system', // 'system' or locale code like 'en', 'es'
      
      // Accessibility
      'reduceAnimations': false,
      'highContrast': false,
      
      // App behavior
      'firstLaunch': true,
      'lastVersion': '1.0.0',
    };
  }

  /// Callback for app state changes - override this in your main app
  static VoidCallback? _onAppStateChanged;
  
  /// Set the callback for when settings change
  static void setAppStateChangeCallback(VoidCallback callback) {
    _onAppStateChanged = callback;
  }
  
  /// Notify app of state changes
  static void _notifyAppStateChange() {
    _onAppStateChanged?.call();
  }

  /// Convenience methods for common settings
  static ThemeMode get themeMode {
    final mode = get<String>('themeMode') ?? 'system';
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Color get accentColor {
    final colorString = get<String>('accentColor') ?? '0xFF2196F3';
    try {
      return Color(int.parse(colorString));
    } catch (e) {
      return Colors.blue; // Fallback
    }
  }

  static Future<void> setAccentColor(Color color) async {
    await set('accentColor', '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}');
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await set('themeMode', modeString);
  }

  /// Debug method to print all settings
  static void debugPrintSettings() {
    print('=== App Settings ===');
    _settings.forEach((key, value) {
      print('$key: $value');
    });
    print('==================');
  }
} 