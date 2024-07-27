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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Language Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'en',
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
          ),
          ListTile(
            title:
                const Text('Українська', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'uk',
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
          ),
          ListTile(
            title:
                const Text('Français', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'fr',
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
          ),
          ListTile(
            title: const Text('Español', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'es',
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
          ),
          ListTile(
            title:
                const Text('Italiano', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'it',
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
          ),
          ListTile(
            title:
                const Text('Português', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'pt',
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
          ),
          ListTile(
            title: const Text('Polski', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'pl',
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
          ),
          ListTile(
            title: const Text('Norsk', style: TextStyle(color: Colors.white)),
            trailing: Radio<String>(
              value: 'no',
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
          ),
        ],
      ),
    );
  }
}
