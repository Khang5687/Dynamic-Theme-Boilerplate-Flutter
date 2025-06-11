import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../core/theme/app_colors.dart';
import '../core/settings/app_settings.dart';

/// Fallback fonts for specific locales (Asian languages)
const Set<String> fallbackFontLocales = {
  "zh",
  "zh_Hant", 
  "ja",
  "ko",
};

/// Custom text widget with theme integration and advanced features
/// Based on the budget app's TextFont widget
class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final String? colorName; // Use named colors from theme
  final TextAlign textAlign;
  final int? maxLines;
  final bool? shadow;
  final bool autoSizeText;
  final double? minFontSize;
  final double? maxFontSize;
  final TextOverflow? overflow;
  final Widget? overflowReplacement;
  final bool? softWrap;
  final List<TextSpan>? richTextSpan;
  final bool selectableText;
  final double? letterSpacing;
  final double? height;

  const AppText(
    this.text, {
    Key? key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.colorName,
    this.maxLines,
    this.shadow = false,
    this.selectableText = false,
    this.richTextSpan,
    this.autoSizeText = false,
    this.maxFontSize,
    this.minFontSize,
    this.overflow,
    this.softWrap,
    this.overflowReplacement,
    this.letterSpacing,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine final text color
    Color finalTextColor = textColor ?? 
        (colorName != null ? getColor(context, colorName!) : getColor(context, "text"));
    
    // Apply contrast enhancement if enabled
    if (AppSettings.getWithDefault<bool>('increaseTextContrast', false)) {
      double threshold = Theme.of(context).brightness == Brightness.light ? 0.7 : 0.65;
      if (finalTextColor.alpha.toDouble() < (255 * threshold)) {
        finalTextColor = finalTextColor.withOpacity(threshold);
      }
    }

    // Get current locale and font settings
    String locale = AppSettings.getWithDefault<String>('locale', 'system');
    String fontFamily = AppSettings.getWithDefault<String>('font', 'Avenir');
    
    // Smart font fallback system (like budget app)
    String finalFontFamily = _getFinalFontFamily(fontFamily, locale);
    List<String> fontFallbacks = _getFontFallbacks(fontFamily, locale);

    final TextStyle textStyle = TextStyle(
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: finalFontFamily == 'system' ? null : finalFontFamily,
      fontFamilyFallback: fontFallbacks,
      color: finalTextColor,
      height: height,
      shadows: shadow == true
          ? [
              const Shadow(
                offset: Offset(0.0, 0.5),
                blurRadius: 8.0,
                color: Color(0x65000000),
              ),
            ]
          : null,
    );

    // Calculate font offset for certain fonts (like Avenir in budget app)
    double fontOffset = 0;
    if (finalFontFamily == 'Avenir' && !fallbackFontLocales.contains(locale)) {
      fontOffset = fontSize * 0.1;
    }

    Widget textWidget = Transform.translate(
      offset: Offset(0, fontOffset),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: textStyle,
        child: _buildTextChild(),
      ),
    );

    return textWidget;
  }

  Widget _buildTextChild() {
    if (selectableText) {
      return SelectableText(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: null, // Style is applied by AnimatedDefaultTextStyle
      );
    }

    if (richTextSpan != null) {
      return RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.ellipsis,
        text: TextSpan(
          text: text,
          children: richTextSpan,
        ),
      );
    }

    if (autoSizeText) {
      return AutoSizeText(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflowReplacement != null ? null : overflow ?? TextOverflow.ellipsis,
        minFontSize: minFontSize ?? fontSize - 4,
        maxFontSize: maxFontSize ?? fontSize + 4,
        softWrap: softWrap,
        overflowReplacement: overflowReplacement,
        style: null, // Style is applied by AnimatedDefaultTextStyle
      );
    }

    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap,
      style: null, // Style is applied by AnimatedDefaultTextStyle
    );
  }
}

/// Helper function to generate rich text spans with bold text
/// Similar to the budget app's generateSpans function
List<TextSpan> generateTextSpans({
  required BuildContext context,
  required String mainText,
  required String? boldText,
  required double fontSize,
  Color? textColor,
  String? colorName,
}) {
  List<TextSpan> spans = [];
  
  if (boldText == null || boldText.isEmpty) {
    spans.add(TextSpan(
      text: mainText,
      style: _getSpanTextStyle(context, fontSize, textColor, colorName, false),
    ));
    return spans;
  }

  // Replace text with case-insensitive matching
  mainText = mainText.replaceAllMapped(
    RegExp(boldText, caseSensitive: false), 
    (match) => boldText,
  );
  
  final List<String> textParts = mainText.split(boldText);

  for (int i = 0; i < textParts.length; i++) {
    if (textParts[i].isNotEmpty) {
      spans.add(TextSpan(
        text: textParts[i],
        style: _getSpanTextStyle(context, fontSize, textColor, colorName, false),
      ));
    }

    if (i < textParts.length - 1) {
      spans.add(TextSpan(
        text: boldText,
        style: _getSpanTextStyle(context, fontSize, textColor, colorName, true),
      ));
    }
  }

  return spans;
}

TextStyle _getSpanTextStyle(
  BuildContext context, 
  double fontSize, 
  Color? textColor, 
  String? colorName, 
  bool isBold,
) {
  Color finalColor = textColor ?? 
      (colorName != null ? getColor(context, colorName) : getColor(context, "text"));
  
  String fontFamily = AppSettings.getWithDefault<String>('font', 'system');
  
  return TextStyle(
    color: finalColor,
    fontFamily: fontFamily == 'system' ? null : fontFamily,
    fontSize: fontSize,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  );
}

/// Smart font fallback system (like budget app)
String _getFinalFontFamily(String fontFamily, String locale) {
  // Handle Asian locales - switch to fonts with better character support
  if (fallbackFontLocales.contains(locale)) {
    switch (fontFamily) {
      case 'Avenir':
        return 'DMSans'; // DMSans has better Asian character support
      case 'YourFont': // Replace with your custom font name
        return 'Inter'; // Fallback to Inter for Asian locales
      default:
        return fontFamily;
    }
  }
  return fontFamily;
}

List<String> _getFontFallbacks(String fontFamily, String locale) {
  // Create comprehensive fallback chain
  List<String> fallbacks = [];
  
  // Add locale-specific fallbacks first
  if (fallbackFontLocales.contains(locale)) {
    fallbacks.addAll(['DMSans', 'Inter']);
  } else {
    fallbacks.add('Inter');
  }
  
  // Add font-specific fallbacks
  switch (fontFamily) {
    case 'Avenir':
      fallbacks.addAll(['Inter', 'DMSans']);
      break;
    case 'YourFont': // Replace with your custom font
      fallbacks.addAll(['Inter', 'Avenir', 'DMSans']);
      break;
    case 'DMSans':
      fallbacks.addAll(['Inter', 'Avenir']);
      break;
    case 'Inter':
      fallbacks.addAll(['DMSans', 'Avenir']);
      break;
    default:
      fallbacks.addAll(['Inter', 'DMSans']);
  }
  
  // Remove duplicates while preserving order
  return fallbacks.toSet().toList();
}

/// Convenience constructors for common text styles
extension AppTextStyles on AppText {
  /// Create a heading text
  static AppText heading(
    String text, {
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
    String? colorName,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return AppText(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textColor: color,
      colorName: colorName,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Create a body text
  static AppText body(
    String text, {
    double fontSize = 16,
    Color? color,
    String? colorName,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return AppText(
      text,
      fontSize: fontSize,
      textColor: color,
      colorName: colorName,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// Create a caption text
  static AppText caption(
    String text, {
    double fontSize = 12,
    Color? color,
    String? colorName = "textLight",
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
  }) {
    return AppText(
      text,
      fontSize: fontSize,
      textColor: color,
      colorName: colorName,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
} 