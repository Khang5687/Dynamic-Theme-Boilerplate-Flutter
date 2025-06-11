import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/material_you.dart';
import 'core/theme/ios_theme.dart';
import 'widgets/app_text.dart';
import 'pages/settings_page.dart';

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
      title: 'Theme Foundation Demo',
      
      // Use the theme foundation
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: AppTheme.themeMode,
      
      home: const HomePage(),
      
      // Optional: Add debug banner control
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Theme Foundation Demo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          colorName: 'text',
        ),
        actions: [
          IconButton(
            icon: Icon(
              AppTheme.isDark(context) ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () async {
              // Toggle theme mode
              final currentMode = AppTheme.themeMode;
              if (currentMode == ThemeMode.light) {
                await AppTheme.setThemeMode(ThemeMode.dark);
              } else if (currentMode == ThemeMode.dark) {
                await AppTheme.setThemeMode(ThemeMode.system);
              } else {
                await AppTheme.setThemeMode(ThemeMode.light);
              }
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading examples
            AppTextStyles.heading(
              'Theme Foundation Features',
              colorName: 'text',
            ),
            const SizedBox(height: 16),
            
            // Body text examples
            AppTextStyles.body(
              'This demo showcases the theme foundation extracted from the budget app. '
              'It includes a complete theming system with:',
            ),
            const SizedBox(height: 12),
            
            // Feature list
            ...featureList.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '• ',
                    fontSize: 16,
                    colorName: 'primary',
                    fontWeight: FontWeight.bold,
                  ),
                  Expanded(
                    child: AppTextStyles.body(feature),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Color showcase
            AppTextStyles.heading(
              'Color System',
              fontSize: 20,
              colorName: 'text',
            ),
            const SizedBox(height: 16),
            
            // Color examples
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colorExamples.map((colorExample) => 
                _buildColorExample(context, colorExample)
              ).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Text style examples
            AppTextStyles.heading(
              'Text Styles',
              fontSize: 20,
              colorName: 'text',
            ),
            const SizedBox(height: 16),
            
            ...textStyleExamples.map((example) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextStyles.caption(
                    example['description']!,
                    colorName: 'textLight',
                  ),
                  const SizedBox(height: 4),
                  example['widget'] as Widget,
                ],
              ),
            )),
            
            const SizedBox(height: 24),
            
            // Settings showcase
            AppTextStyles.heading(
              'Settings Demo',
              fontSize: 20,
              colorName: 'text',
            ),
            const SizedBox(height: 16),
            
            _buildSettingsSection(context),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        },
        child: const Icon(Icons.settings),
        tooltip: 'Open Settings',
      ),
    );
  }

  Widget _buildColorExample(BuildContext context, Map<String, String> colorExample) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: getColor(context, colorExample['colorName']!),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: getColor(context, 'border'),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            colorExample['name']!,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            textColor: _getContrastingColor(context, colorExample['colorName']!),
          ),
          const SizedBox(height: 4),
          AppText(
            colorExample['colorName']!,
            fontSize: 10,
            textColor: _getContrastingColor(context, colorExample['colorName']!),
          ),
        ],
      ),
    );
  }

  Color _getContrastingColor(BuildContext context, String colorName) {
    final color = getColor(context, colorName);
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Current Settings:',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            
            AppText(
              'Theme Mode: ${AppTheme.themeMode.name}',
              fontSize: 14,
              colorName: 'textLight',
            ),
            AppText(
              'Font: ${AppSettings.getWithDefault<String>('font', 'system')}',
              fontSize: 14,
              colorName: 'textLight',
            ),
            AppText(
              'Contrast Enhanced: ${AppSettings.getWithDefault<bool>('increaseTextContrast', false)}',
              fontSize: 14,
              colorName: 'textLight',
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Toggle contrast setting
                      bool currentContrast = AppSettings.getWithDefault<bool>('increaseTextContrast', false);
                      await AppSettings.set('increaseTextContrast', !currentContrast);
                    },
                    child: const AppText(
                      'Toggle Contrast',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _cycleFonts(),
                    child: const AppText(
                      'Change Font',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _changeAccentColor() async {
    final colors = getSelectableColors();
    final currentColor = AppSettings.accentColor;
    
    // Find next color in the list
    int currentIndex = colors.indexWhere((c) => c.value == currentColor.value);
    int nextIndex = (currentIndex + 1) % colors.length;
    
    await AppTheme.setAccentColor(colors[nextIndex]);
  }

  void _cycleFonts() async {
    final availableFonts = ['Avenir', 'Inter', 'DMSans', 'system'];
    final currentFont = AppSettings.getWithDefault<String>('font', 'Avenir');
    
    // Find next font in the list
    int currentIndex = availableFonts.indexOf(currentFont);
    int nextIndex = (currentIndex + 1) % availableFonts.length;
    
    await AppSettings.set('font', availableFonts[nextIndex]);
  }
}

// Data for the demo
const List<String> featureList = [
  'Dynamic light/dark theming with automatic color adaptation',
  'Named color system with semantic color names',
  'Advanced text widget with auto-sizing and rich text support',
  'Persistent settings with automatic app state management',
  'Localization support with font fallbacks for Asian languages',
  'Accessibility features like contrast enhancement',
  'Material You color integration',
  'Easy theme customization and accent color changes',
];

final List<Map<String, String>> colorExamples = [
  {'name': 'Primary', 'colorName': 'primary'},
  {'name': 'Text', 'colorName': 'text'},
  {'name': 'Text Light', 'colorName': 'textLight'},
  {'name': 'Success', 'colorName': 'success'},
  {'name': 'Error', 'colorName': 'error'},
  {'name': 'Warning', 'colorName': 'warning'},
  {'name': 'Info', 'colorName': 'info'},
  {'name': 'Surface', 'colorName': 'surface'},
];

final List<Map<String, dynamic>> textStyleExamples = [
  {
    'description': 'Heading Style (24px, Bold)',
    'widget': AppTextStyles.heading('This is a heading'),
  },
  {
    'description': 'Body Style (16px, Normal)',
    'widget': AppTextStyles.body('This is body text with normal weight'),
  },
  {
    'description': 'Caption Style (12px, Light Color)',
    'widget': AppTextStyles.caption('This is caption text in light color'),
  },
  {
    'description': 'Custom Style with Color Name',
    'widget': AppText(
      'This text uses the success color',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      colorName: 'success',
    ),
  },
  {
    'description': 'Auto-sizing Text',
    'widget': Container(
      width: 150,
      child: AppText(
        'This text will automatically resize to fit the container width',
        autoSizeText: true,
        maxLines: 2,
        fontSize: 16,
      ),
    ),
  },
]; 