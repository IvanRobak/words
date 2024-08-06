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

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
          _buildLanguageOption('English', 'en'),
          _buildLanguageOption('Українська', 'uk'),
          _buildLanguageOption('Français', 'fr'),
          _buildLanguageOption('Español', 'es'),
          _buildLanguageOption('Italiano', 'it'),
          _buildLanguageOption('Português', 'pt'),
          _buildLanguageOption('Polski', 'pl'),
          _buildLanguageOption('Norsk', 'no'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String languageName, String languageCode) {
    return ListTile(
      title: Text(languageName, style: const TextStyle(color: Colors.white)),
      trailing: Radio<String>(
        value: languageCode,
        groupValue: _selectedLanguage,
        activeColor: Theme.of(context).colorScheme.secondary,
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.secondary;
          }
          return Colors.white;
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
