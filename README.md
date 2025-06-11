![Demo](https://github.com/Khang5687/Flutter-Theme-Foundation/blob/main/promotional/github/demo.gif)

# 🎨 Theme Foundation

A comprehensive, production-ready theming system for Flutter applications, extracted and enhanced from a sophisticated budget app. This foundation provides Material You support, iOS design integration, advanced color management, intelligent font handling, and comprehensive accessibility features.

## ✨ Features Overview


### 🌈 **Advanced Color System**
- **Named Colors**: Use semantic color names like `"text"`, `"primary"`, `"success"`, `"error"`
- **Automatic Light/Dark Variants**: Colors automatically adapt to theme mode
- **Material You Integration**: Dynamic colors from Android 12+ system wallpapers
- **iOS System Colors**: Platform-appropriate color handling for iOS
- **Custom Color Support**: Full HSV color picker with Material Design integration

### 🎯 **Material You Support**
- **Dynamic Colors**: Automatic wallpaper-based color extraction (Android 12+)
- **Intelligent Fallbacks**: Graceful degradation for unsupported platforms
- **System Accent Colors**: Platform-native accent color integration
- **Real-time Detection**: Smart platform capability detection

### 🍎 **iOS Platform Integration**
- **Cupertino Design**: Native iOS components and styling
- **System Font Support**: SF Pro and iOS system fonts
- **Adaptive Widgets**: Components that use Material on Android, Cupertino on iOS
- **iOS Color System**: Complete iOS semantic color palette
- **Haptic Feedback**: Platform-appropriate haptic responses

### 🔤 **Smart Font System**
- **Multi-Font Support**: Avenir, Inter, DM Sans, and custom fonts
- **Intelligent Fallbacks**: Automatic font switching for different locales
- **Asian Locale Support**: Smart fallbacks for Chinese, Japanese, Korean text
- **Custom Font Loading**: Easy integration of custom font families
- **Platform Optimization**: iOS and Android font optimization

### 🎨 **Comprehensive Theme Management**
- **Light/Dark/System Modes**: Full theme mode support with system detection
- **Real-time Theme Switching**: Instant theme updates throughout the app
- **Persistent Settings**: All preferences saved and restored automatically
- **Theme Callbacks**: React to theme changes anywhere in your app

### ♿ **Accessibility Features**
- **Enhanced Text Contrast**: Improved readability for accessibility needs
- **Animation Reduction**: Respect user motion sensitivity preferences
- **Semantic Colors**: Colors designed for accessibility compliance
- **Font Size Scaling**: Responsive text sizing with auto-size text support

### 🎛️ **Advanced Settings System**
- **Type-Safe Settings**: Strongly typed setting values with defaults
- **Persistent Storage**: Automatic SharedPreferences integration
- **Change Callbacks**: React to setting changes throughout your app
- **Validation**: Built-in validation for setting values

## 🚀 Quick Start

### 1. **Installation**

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  auto_size_text: ^3.0.0
  flutter_colorpicker: ^1.0.3
  dynamic_color: ^1.6.8
```

### 2. **Basic Setup**

```dart
import 'package:flutter/material.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/material_you.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the settings system
  await AppSettings.initialize();
  
  // Initialize Material You system
  await MaterialYouManager.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    // React to theme changes
    AppSettings.setAppStateChangeCallback(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: AppTheme.themeMode,
      home: YourHomePage(),
    );
  }
}
```

### 3. **Using the Theme System**

```dart
import 'widgets/app_text.dart';
import 'core/colors/app_colors.dart';

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor(context, 'surface'),
      child: Column(
        children: [
          // Semantic text with automatic theming
          AppText(
            'Hello World',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            colorName: 'text',
          ),
          
          // Success message
          AppText(
            'Operation completed successfully',
            colorName: 'success',
          ),
          
          // Error message with enhanced contrast
          AppText(
            'Something went wrong',
            colorName: 'error',
            enhanceContrast: true,
          ),
        ],
      ),
    );
  }
}
```

## 📱 **Platform Support**

### **Android**
- ✅ Material Design 3
- ✅ Material You (Android 12+)
- ✅ Dynamic colors from wallpaper
- ✅ System accent colors
- ✅ All font families supported

### **iOS**
- ✅ Cupertino design integration
- ✅ iOS system colors
- ✅ SF Pro system font
- ✅ Adaptive widgets
- ✅ Haptic feedback

### **Web/Desktop**
- ✅ Material Design 3
- ⚠️ Limited system integration
- ✅ Custom color support
- ✅ Font loading

## 🎨 **Color System Deep Dive**

### **Named Colors**

The theme foundation uses semantic color names for consistent theming:

```dart
// Primary application colors
getColor(context, 'text')           // Main text color
getColor(context, 'textLight')      // Secondary text color
getColor(context, 'primary')        // Brand/accent color
getColor(context, 'secondary')      // Secondary brand color

// Status colors
getColor(context, 'success')        // Success states
getColor(context, 'warning')        // Warning states
getColor(context, 'error')          // Error states
getColor(context, 'info')           // Information states

// Surface colors
getColor(context, 'surface')        // Main background
getColor(context, 'surfaceContainer') // Card backgrounds
getColor(context, 'divider')        // Dividers and borders
```

### **Material You Integration**

```dart
// Check Material You status
bool isSupported = MaterialYouManager.isSupported();
bool hasDynamicColors = MaterialYouManager.hasDynamicColors();
String status = MaterialYouManager.getStatusMessage();

// Get system colors
Color accentColor = MaterialYouManager.getAccentColor();
ColorScheme dynamicScheme = MaterialYouManager.createColorScheme(
  brightness: Brightness.light,
);

// Use Material You surfaces
Color surface = MaterialYouManager.getSurfaceColor(
  context, 
  elevation: 2,
);
```

### **Custom Color Creation**

```dart
// Add your own colors to the system
AppColors getCustomColors(Brightness brightness, ThemeData theme, Color accent) {
  return AppColors(
    // ... existing colors
    customBrand: brightness == Brightness.light 
        ? const Color(0xFF6B46C1) 
        : const Color(0xFF8B5CF6),
    customSuccess: Colors.green.shade600,
  );
}
```

## 🔤 **Font System Deep Dive**

### **Available Fonts**

```dart
// Built-in fonts with automatic fallbacks
'Avenir'    // Modern geometric sans-serif
'Inter'     // Optimized for UI and reading
'DMSans'    // Clean, geometric design
'system'    // Platform default (SF Pro on iOS, Roboto on Android)
```

### **Smart Font Fallbacks**

The system automatically provides appropriate fallbacks:

```dart
// For Asian locales (zh, ja, ko)
'Avenir' → 'DMSans' → 'Inter' → System Default

// For other locales
Selected Font → System Default
```

### **Custom Font Integration**

Add your fonts to `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: fonts/CustomFont-Regular.ttf
        - asset: fonts/CustomFont-Bold.ttf
          weight: 700
```

Update the font list in settings:

```dart
final availableFonts = ['Avenir', 'Inter', 'DMSans', 'CustomFont', 'system'];
```

### **Font Usage Examples**

```dart
// Basic text with current font setting
AppText('Hello World')

// Override font family
AppText(
  'Special Text',
  fontFamily: 'CustomFont',
)

// Auto-sizing text with font fallbacks
AppText(
  'This text will resize automatically',
  autoSizeText: true,
  minFontSize: 12,
  maxFontSize: 24,
)

// Enhanced contrast for accessibility
AppText(
  'Important message',
  enhanceContrast: true,
  colorName: 'text',
)
```

## 🎛️ **Settings System**

### **Available Settings**

```dart
// Theme settings
AppSettings.themeMode                    // ThemeMode (light/dark/system)
AppSettings.accentColor                  // Color (user's accent color)
AppSettings.getWithDefault<bool>('materialYou', false)
AppSettings.getWithDefault<bool>('useSystemAccent', false)

// Text settings
AppSettings.getWithDefault<String>('fontFamily', 'Avenir')
AppSettings.getWithDefault<bool>('increaseTextContrast', false)

// Accessibility settings
AppSettings.getWithDefault<bool>('reduceAnimations', false)
```

### **Setting Values**

```dart
// Set a value
await AppSettings.set('materialYou', true);
await AppSettings.setThemeMode(ThemeMode.dark);
await AppSettings.setAccentColor(Colors.purple);

// Get values with type safety
bool materialYou = AppSettings.getWithDefault<bool>('materialYou', false);
String font = AppSettings.getWithDefault<String>('fontFamily', 'Avenir');
int customValue = AppSettings.getWithDefault<int>('customSetting', 42);

// React to changes
AppSettings.setAppStateChangeCallback(() {
  print('Settings changed - rebuild UI');
});
```

### **Custom Settings**

Add your own settings to the defaults:

```dart
// In app_settings.dart defaults
'customFeature': true,
'userLevel': 'beginner',
'maxItems': 100,
```

## 🍎 **iOS Integration**

### **Adaptive Widgets**

```dart
// Automatically uses Material on Android, Cupertino on iOS
IOSTheme.adaptiveButton(
  onPressed: () {},
  isPrimary: true,
  child: Text('Tap me'),
)

IOSTheme.adaptiveAppBar(
  title: 'My App',
  actions: [IconButton(...)],
)

IOSTheme.adaptiveScaffold(
  appBar: appBar,
  body: body,
  floatingActionButton: fab,
)
```

### **iOS System Colors**

```dart
// Get iOS-specific colors
Map<String, Color> iosColors = IOSTheme.getIOSSystemColors(Brightness.light);
Color label = iosColors['label']!;
Color systemBlue = iosColors['systemBlue']!;
```

### **Haptic Feedback**

```dart
// Platform-appropriate haptic feedback
IOSTheme.hapticFeedback(HapticFeedbackType.light);
IOSTheme.hapticFeedback(HapticFeedbackType.medium);
IOSTheme.hapticFeedback(HapticFeedbackType.heavy);
IOSTheme.hapticFeedback(HapticFeedbackType.selection);
```

## ♿ **Accessibility Features**

### **Enhanced Text Contrast**

```dart
// Automatic contrast enhancement
AppText(
  'Important text',
  enhanceContrast: true, // Respects user setting
  colorName: 'text',
)

// Check if enhanced contrast is enabled
bool enhanceContrast = AppSettings.getWithDefault<bool>('increaseTextContrast', false);
```

### **Animation Reduction**

```dart
// Respect user's motion preferences
bool reduceAnimations = AppSettings.getWithDefault<bool>('reduceAnimations', false);

Duration animationDuration = reduceAnimations 
    ? Duration.zero 
    : Duration(milliseconds: 300);

AnimatedContainer(
  duration: animationDuration,
  // ... other properties
)
```

### **Semantic Colors**

All colors are designed with accessibility in mind:

```dart
// High contrast color combinations
getColor(context, 'error')    // Meets WCAG AA standards
getColor(context, 'success')  // Accessible green
getColor(context, 'warning')  // Accessible amber
```

## 🔧 **Advanced Customization**

### **Creating Custom Themes**

```dart
// Create a custom theme variant
ThemeData createCustomTheme() {
  return AppTheme.lightTheme(
    accentColor: Colors.purple,
  ).copyWith(
    // Your custom overrides
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
```

### **Custom Color Schemes**

```dart
// Override the color generation
AppColors getCustomAppColors(Brightness brightness, ThemeData theme, Color accent) {
  final base = getAppColors(brightness, theme, accent);
  return base.copyWith(
    // Custom overrides
    customColor: brightness == Brightness.light ? Colors.blue : Colors.lightBlue,
  );
}
```

### **Advanced Text Styling**

```dart
// Create text style presets
class AppTextStyles {
  static Widget heading(String text, {String? colorName}) {
    return AppText(
      text,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      colorName: colorName ?? 'text',
    );
  }
  
  static Widget body(String text, {String? colorName}) {
    return AppText(
      text,
      fontSize: 16,
      colorName: colorName ?? 'text',
    );
  }
  
  static Widget caption(String text, {String? colorName}) {
    return AppText(
      text,
      fontSize: 12,
      colorName: colorName ?? 'textLight',
    );
  }
}
```

## 🛠️ **Development & Debugging**

### **Debug Information**

```dart
// Get detailed theme status
Map<String, dynamic> debugInfo = MaterialYouManager.getDebugInfo();
print('Material You Status: ${debugInfo['statusMessage']}');
print('Platform: ${debugInfo['platform']}');
print('Has Dynamic Colors: ${debugInfo['hasDynamicColors']}');

// Check current settings
Map<String, dynamic> allSettings = AppSettings.getAllSettings();
print('Current Settings: $allSettings');
```

### **Testing Different Configurations**

```dart
// Test different theme configurations
await AppSettings.set('materialYou', true);
await AppSettings.set('fontFamily', 'Inter');
await AppSettings.set('increaseTextContrast', true);
await AppSettings.setThemeMode(ThemeMode.dark);
```

## 🌟 **Migration Guide**

### **From Basic Material Theme**

1. Replace `Theme.of(context).colorScheme.primary` with `getColor(context, 'primary')`
2. Replace `Text()` widgets with `AppText()` for automatic theming
3. Add settings initialization to your `main()` function
4. Use semantic color names instead of direct color references

### **Adding to Existing App**

1. Copy the theme foundation into your project
2. Initialize in `main()`:
   ```dart
   await AppSettings.initialize();
   await MaterialYouManager.initialize();
   ```
3. Update your `MaterialApp`:
   ```dart
   theme: AppTheme.lightTheme(),
   darkTheme: AppTheme.darkTheme(),
   themeMode: AppTheme.themeMode,
   ```
4. Gradually replace widgets with theme-aware versions

## 📄 **License**

This theme foundation is based on advanced theming techniques and is distributed under the GPL-3.0 license. You are free to modify and expand it to suit your particular requirements.

---

## 🤝 **Contributing**

This theme foundation serves as a starting point for sophisticated app theming. Key areas for extension:

1. **Additional Color Schemes**: Create industry-specific color palettes
2. **More Font Families**: Add support for additional custom fonts
3. **Platform Extensions**: Enhance macOS and Windows integration
4. **Animation Systems**: Build on the animation reduction foundation
5. **Component Themes**: Extend theming to more widget types

The foundation is designed to be highly extensible while maintaining consistency and accessibility across all platforms. 