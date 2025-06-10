# 🎨 Flutter Theme Foundation

A comprehensive, production-ready theming system extracted and adapted from the budget app's excellent theme architecture. This foundation provides everything you need for a sophisticated, accessible, and maintainable theming system in your Flutter app.

## ✨ Features

- **🌓 Dynamic Light/Dark Theming** - Automatic color adaptation with smooth transitions
- **🎯 Named Color System** - Semantic color names instead of hardcoded values
- **📱 Advanced Text Widget** - Auto-sizing, rich text, accessibility features
- **⚙️ Persistent Settings** - Automatic app state management with SharedPreferences
- **🌍 Localization Ready** - Font fallbacks for Asian languages
- **♿ Accessibility First** - Contrast enhancement, font scaling
- **🎨 Material You Support** - Dynamic color integration (optional)
- **🔧 Easy Customization** - Simple accent color changes and theme switching

## 🚀 Quick Start

### 1. Set up dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2
  auto_size_text: ^3.0.0
```

### 2. Initialize the system

In your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'widgets/app_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the settings system
  await AppSettings.initialize();
  
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
    
    // Set up callback for theme changes
    AppSettings.setAppStateChangeCallback(() {
      setState(() {
        // This will rebuild the app with new theme settings
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      
      // Use the theme foundation
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: AppTheme.themeMode,
      
      home: YourHomePage(),
    );
  }
}
```

### 3. Use the text widget

Replace `Text` widgets with `AppText`:

```dart
// Before
Text(
  'Hello World',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)

// After
AppText(
  'Hello World',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  colorName: 'text', // Uses theme-aware colors
)

// Or use convenience constructors
AppTextStyles.heading('This is a heading')
AppTextStyles.body('This is body text')
AppTextStyles.caption('This is caption text')
```

### 4. Use the color system

```dart
// Get theme-aware colors
Container(
  color: getColor(context, 'surface'),
  child: AppText(
    'Themed content',
    colorName: 'textLight',
  ),
)
```

## 🎨 Color System

The theme foundation includes a comprehensive named color system:

### Basic Colors
- `"text"` - Primary text color
- `"textLight"` - Secondary/light text
- `"textSecondary"` - Tertiary text
- `"background"` - Main background
- `"surface"` - Surface backgrounds
- `"primary"` - Primary accent color

### Semantic Colors
- `"success"` - Success/positive actions
- `"error"` - Error/negative actions  
- `"warning"` - Warning/caution
- `"info"` - Information/neutral

### UI Colors
- `"border"` - Border colors
- `"divider"` - Divider lines
- `"shadow"` - Drop shadows
- `"overlay"` - Modal overlays

## 📝 Advanced Text Features

### Auto-sizing Text
```dart
AppText(
  'This text will automatically resize to fit',
  autoSizeText: true,
  maxLines: 2,
  fontSize: 16,
)
```

### Rich Text with Bold
```dart
AppText(
  'Regular text',
  richTextSpan: generateTextSpans(
    context: context,
    mainText: 'This has bold text inside',
    boldText: 'bold',
    fontSize: 16,
  ),
)
```

### Selectable Text
```dart
AppText(
  'This text can be selected and copied',
  selectableText: true,
)
```

### Custom Colors
```dart
AppText(
  'Success message',
  colorName: 'success',
  fontWeight: FontWeight.bold,
)
```

## ⚙️ Settings Management

### Get Settings
```dart
// With type safety
String font = AppSettings.get<String>('font') ?? 'system';

// With default fallback
bool contrastMode = AppSettings.getWithDefault<bool>('increaseTextContrast', false);
```

### Update Settings
```dart
// Update and trigger app rebuild
await AppSettings.set('increaseTextContrast', true);

// Update without triggering rebuild
await AppSettings.set('someKey', 'value', notifyListeners: false);
```

### Theme Controls
```dart
// Change theme mode
await AppTheme.setThemeMode(ThemeMode.dark);

// Change accent color
await AppTheme.setAccentColor(Colors.purple);

// Check current theme
bool isDark = AppTheme.isDark(context);
```

## 🌍 Localization Support

The system automatically handles font fallbacks for Asian languages:

```dart
// In AppSettings defaults
'locale': 'system', // or 'zh', 'ja', 'ko', etc.
'font': 'system',   // Will use Noto Sans for Asian locales
```

## ♿ Accessibility Features

### Text Contrast Enhancement
```dart
// Enable in settings
await AppSettings.set('increaseTextContrast', true);

// Colors automatically adjust for better contrast
```

### Font Scaling
The text widget respects system font scaling and provides auto-sizing capabilities.

## 📁 File Structure

```
lib/
├── core/
│   ├── settings/
│   │   └── app_settings.dart          # Settings management
│   └── theme/
│       ├── app_colors.dart            # Color system
│       └── app_theme.dart             # Theme configuration
├── widgets/
│   └── app_text.dart                  # Advanced text widget
└── main.dart                          # Demo/setup example
```

## 🔧 Customization

### Add Custom Colors
In `app_colors.dart`, add to the color maps:

```dart
// Light theme colors
"myCustomColor": Color(0xFF123456),

// Dark theme colors  
"myCustomColor": Color(0xFF654321),
```

### Add Custom Settings
In `app_settings.dart`, add to `_getDefaultSettings()`:

```dart
'myCustomSetting': 'defaultValue',
```

### Custom Fonts
Add fonts to `pubspec.yaml` and use:

```dart
await AppSettings.set('font', 'MyCustomFont');
```

## 🎯 Best Practices

1. **Always use `AppText`** instead of `Text` for consistency
2. **Use named colors** instead of hardcoded colors
3. **Test in both light and dark modes**
4. **Enable contrast mode** for accessibility testing
5. **Use the settings system** for any user preferences
6. **Set up the state callback** for theme changes

## 🔄 Migration from Basic Text

```dart
// Replace this:
Text(
  'Hello',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)

// With this:
AppText(
  'Hello',
  fontSize: 18,
  fontWeight: FontWeight.bold,
  colorName: 'text', // Automatically theme-aware
)
```

## 🎨 Theme Switching Example

```dart
// Theme toggle button
IconButton(
  icon: Icon(AppTheme.isDark(context) ? Icons.light_mode : Icons.dark_mode),
  onPressed: () async {
    final currentMode = AppTheme.themeMode;
    await AppTheme.setThemeMode(
      currentMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light
    );
  },
)
```

## 📱 Platform Considerations

- **iOS**: Respects system fonts and design patterns
- **Android**: Supports Material You (when enabled)
- **Web**: Fully responsive and accessible
- **Desktop**: Optimized for larger screens

## 🤝 Contributing

This foundation is based on the excellent theming system from the budget app. Feel free to:

1. Add new color variants
2. Enhance the text widget features
3. Improve accessibility
4. Add platform-specific optimizations

## 📄 License

This theme foundation is provided as-is for educational and development purposes. The original budget app's theming system inspired this implementation.

---

**Ready to build beautiful, themed Flutter apps!** 🚀 