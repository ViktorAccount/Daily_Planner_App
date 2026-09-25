import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/theme_provider.dart';
import '../view_models/font_size_provider.dart';
import '../view_models/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file1


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settingsTitle ?? 'Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.settingsTitle ?? 'UX Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(AppLocalizations.of(context)?.darkMode ?? 'Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.fontSize ?? 'Font Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: fontSizeProvider.fontSize,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: "${(fontSizeProvider.fontSize * 100).toInt()}%",
              onChanged: (newSize) {
                fontSizeProvider.updateFontSize(newSize);
              },
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.language ?? 'Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<Locale>(
              value: localeProvider.locale,
              items: [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('sv'),
                  child: Text('Svenska'),
                ),
              ],
              onChanged: (locale) {
                localeProvider.setLocale(locale!);
              },
            ),
          ],
        ),
      ),
    );
  }
}