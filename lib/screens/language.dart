import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'en';
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Language Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            trailing: Radio<String>(
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Українська'),
            trailing: Radio<String>(
              value: 'uk',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Français'),
            trailing: Radio<String>(
              value: 'fr',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Español'),
            trailing: Radio<String>(
              value: 'es',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Italiano'),
            trailing: Radio<String>(
              value: 'it',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Português'),
            trailing: Radio<String>(
              value: 'pt',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Polski'),
            trailing: Radio<String>(
              value: 'pl',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Norsk'),
            trailing: Radio<String>(
              value: 'no',
              groupValue: _selectedLanguage,
              onChanged: (String? value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
