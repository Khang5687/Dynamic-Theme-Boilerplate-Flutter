import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../core/settings/app_settings.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_colors.dart';
import '../widgets/app_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          'Settings',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSectionHeader('Theme'),
          _buildThemeModeSetting(),
          _buildDivider(),
          
          // Colors Section
          _buildSectionHeader('Colors'),
          _buildAccentColorSelector(),
          _buildCustomColorPicker(),
          _buildDivider(),
          
          // Text Section
          _buildSectionHeader('Text'),
          _buildFontSelector(),
          _buildContrastSetting(),
          _buildDivider(),
          
          // Accessibility Section
          _buildSectionHeader('Accessibility'),
          _buildReduceAnimationsSetting(),
          _buildDivider(),
          
          // About Section
          _buildSectionHeader('About'),
          _buildAboutTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: AppText(
        title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        colorName: 'primary',
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: getColor(context, 'divider'),
    );
  }

  Widget _buildThemeModeSetting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'App Theme',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildThemeModeButton(
                'Light',
                Icons.light_mode,
                ThemeMode.light,
                AppTheme.themeMode == ThemeMode.light,
              ),
              const SizedBox(width: 8),
              _buildThemeModeButton(
                'Dark',
                Icons.dark_mode,
                ThemeMode.dark,
                AppTheme.themeMode == ThemeMode.dark,
              ),
              const SizedBox(width: 8),
              _buildThemeModeButton(
                'System',
                Icons.brightness_auto,
                ThemeMode.system,
                AppTheme.themeMode == ThemeMode.system,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeButton(
    String label,
    IconData icon,
    ThemeMode mode,
    bool isSelected,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          await AppTheme.setThemeMode(mode);
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? getColor(context, 'primary')
              : getColor(context, 'surfaceContainer'),
          foregroundColor: isSelected
              ? Colors.white
              : getColor(context, 'text'),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            AppText(
              label,
              fontSize: 12,
              textColor: isSelected
                  ? Colors.white
                  : getColor(context, 'text'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccentColorSelector() {
    final colors = getSelectableColors();
    final currentColor = AppSettings.accentColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Accent Color',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              final isSelected = color.value == currentColor.value;
              return GestureDetector(
                onTap: () async {
                  await AppTheme.setAccentColor(color);
                  setState(() {});
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? getColor(context, 'text')
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomColorPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Custom Color',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showColorPickerDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: getColor(context, 'surfaceContainer'),
              foregroundColor: getColor(context, 'text'),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppSettings.accentColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getColor(context, 'border'),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const AppText(
                  'Choose Custom Color',
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog() {
    Color pickerColor = AppSettings.accentColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText(
            'Pick a color',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsvWithHue,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const AppText('Cancel', fontSize: 14),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const AppText('Apply', fontSize: 14),
              onPressed: () async {
                await AppTheme.setAccentColor(pickerColor);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFontSelector() {
    final availableFonts = ['Avenir', 'Inter', 'DMSans', 'system'];
    final currentFont = AppSettings.getWithDefault<String>('font', 'Avenir');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Font Family',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableFonts.length,
            itemBuilder: (context, index) {
              final font = availableFonts[index];
              final isSelected = font == currentFont;
              
              // Special case for system font
              String displayName = font == 'system' ? 'System Default' : font;
              String sampleText = 'Sample Text in $displayName';
              
              return ListTile(
                title: AppText(
                  displayName,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: Text(
                  sampleText,
                  style: TextStyle(
                    fontFamily: font == 'system' ? null : font,
                    fontSize: 14,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: getColor(context, 'primary'),
                      )
                    : null,
                onTap: () async {
                  await AppSettings.set('font', font);
                  setState(() {});
                },
              );
            },
          ),
          const SizedBox(height: 8),
          const AppText(
            'Note: Font changes apply to all text in the app.',
            fontSize: 12,
            colorName: 'textLight',
          ),
        ],
      ),
    );
  }

  Widget _buildContrastSetting() {
    final isEnabled = AppSettings.getWithDefault<bool>('increaseTextContrast', false);

    return SwitchListTile(
      title: const AppText(
        'Enhanced Text Contrast',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subtitle: const AppText(
        'Increases contrast for better readability',
        fontSize: 12,
        colorName: 'textLight',
      ),
      value: isEnabled,
      onChanged: (value) async {
        await AppSettings.set('increaseTextContrast', value);
        setState(() {});
      },
      activeColor: getColor(context, 'primary'),
    );
  }

  Widget _buildReduceAnimationsSetting() {
    final isEnabled = AppSettings.getWithDefault<bool>('reduceAnimations', false);

    return SwitchListTile(
      title: const AppText(
        'Reduce Animations',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subtitle: const AppText(
        'Minimizes motion effects throughout the app',
        fontSize: 12,
        colorName: 'textLight',
      ),
      value: isEnabled,
      onChanged: (value) async {
        await AppSettings.set('reduceAnimations', value);
        setState(() {});
      },
      activeColor: getColor(context, 'primary'),
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      title: const AppText(
        'About Theme Foundation',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      subtitle: const AppText(
        'A comprehensive theming system based on the budget app',
        fontSize: 12,
        colorName: 'textLight',
      ),
      trailing: const Icon(Icons.info_outline),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: 'Theme Foundation',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2023',
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: AppText(
                'A comprehensive theming system with support for light/dark modes, custom colors, fonts, and accessibility features.',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
} 