import 'package:flutter_test/flutter_test.dart';
import 'package:dp2/view_models/font_size_provider.dart';
import 'package:dp2/view_models/theme_provider.dart';

void main() {
  group('FontSizeProvider Tests', () {
    test('Default font size is 1.0', () {
      final fontSizeProvider = FontSizeProvider();

      // Verify the default font size
      expect(fontSizeProvider.fontSize, equals(1.0));
    });

    test('updateFontSize updates the font size', () {
      final fontSizeProvider = FontSizeProvider();

      // Update the font size
      fontSizeProvider.updateFontSize(1.5);

      // Verify the updated font size
      expect(fontSizeProvider.fontSize, equals(1.5));
    });
  });

  group('ThemeProvider Tests', () {
    test('Default theme is light mode', () {
      final themeProvider = ThemeProvider();

      // Verify the default theme is light mode
      expect(themeProvider.isDarkMode, equals(false));
    });

    test('toggleTheme switches to dark mode', () {
      final themeProvider = ThemeProvider();

      // Toggle to dark mode
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, equals(true));

      // Toggle back to light mode
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, equals(false));
    });
  });
}
