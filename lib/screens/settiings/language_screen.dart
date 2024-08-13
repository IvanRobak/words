import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String? _selectedLanguage;

  // Future<void> _clearLanguagePreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('selectedLanguage');
  // }

// Виклик цього методу в initState або де потрібно:
  @override
  void initState() {
    super.initState();
    // _clearLanguagePreference();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selectedLanguage');

    if (savedLanguage == null) {
      // Отримуємо мову пристрою через PlatformDispatcher
      Locale deviceLocale = ui.PlatformDispatcher.instance.locale;
      savedLanguage = deviceLocale.languageCode; // 'en', 'uk', etc.
    }

    setState(() {
      _selectedLanguage = savedLanguage;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = languageCode;
    });
    await prefs.setString('selectedLanguage', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language for translate',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: ListView(
        children: [
          _buildLanguageOption('Arabic', 'ar'),
          _buildLanguageOption('Chinese (Simplified)', 'zh-CN'),
          _buildLanguageOption('Chinese (Traditional)', 'zh-TW'),
          _buildLanguageOption('Czech', 'cs'),
          _buildLanguageOption('Danish', 'da'),
          _buildLanguageOption('Dutch', 'nl'),
          _buildLanguageOption('English', 'en'),
          _buildLanguageOption('Español', 'es'),
          _buildLanguageOption('Farsi', 'fa'),
          _buildLanguageOption('Finnish', 'fi'),
          _buildLanguageOption('Français', 'fr'),
          _buildLanguageOption('German', 'de'),
          _buildLanguageOption('Greek', 'el'),
          _buildLanguageOption('Hindi', 'hi'),
          _buildLanguageOption('Hungarian', 'hu'),
          _buildLanguageOption('Indonesian', 'id'),
          _buildLanguageOption('Italiano', 'it'),
          _buildLanguageOption('Japanese', 'ja'),
          _buildLanguageOption('Korean', 'ko'),
          _buildLanguageOption('Norwegian', 'no'),
          _buildLanguageOption('Polish', 'pl'),
          _buildLanguageOption('Portuguese', 'pt'),
          _buildLanguageOption('Swedish', 'sv'),
          _buildLanguageOption('Thai', 'th'),
          _buildLanguageOption('Turkish', 'tr'),
          _buildLanguageOption('Ukrainian', 'uk'),
          _buildLanguageOption('Vietnamese', 'vi'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String languageName, String languageCode) {
    return ListTile(
      title: Text(languageName,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 18)),
      trailing: Radio<String>(
        value: languageCode,
        groupValue: _selectedLanguage,
        activeColor: Theme.of(context).colorScheme.secondary,
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.secondary;
          }
          return Theme.of(context).colorScheme.onSecondary;
        }),
        onChanged: (String? value) {
          if (value != null) {
            _changeLanguage(value);
          }
        },
      ),
    );
  }
}
