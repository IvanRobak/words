// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:words/screens/settiings/about_screen.dart';
import 'package:words/screens/settiings/auth_screen.dart';
import 'package:words/providers/theme_provider.dart';
import 'package:words/screens/settiings/language_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
  }

  Future<void> _toggleSoundSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = value;
    });
    await prefs.setBool('soundEnabled', value);
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final BuildContext currentContext = context;

    Navigator.of(context).pop();

    showDialog(
      context: currentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Data Cleared',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text('Shared preferences cleared',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
          textColor: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Sound'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _toggleSoundSetting(true);
                    },
                    child: Text(
                      'On',
                      style: TextStyle(
                        color: soundEnabled ? Colors.white : Colors.grey,
                        fontWeight:
                            soundEnabled ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _toggleSoundSetting(false);
                    },
                    child: Text(
                      'Off',
                      style: TextStyle(
                        color: !soundEnabled ? Colors.white : Colors.grey,
                        fontWeight:
                            !soundEnabled ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Appearance'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                    child: Text(
                      ref.watch(themeNotifierProvider).isDarkMode
                          ? 'Dark'
                          : 'Light',
                      style: TextStyle(
                        color: ref.watch(themeNotifierProvider).isDarkMode
                            ? Colors.grey
                            : Colors.white,
                        fontWeight: ref.watch(themeNotifierProvider).isDarkMode
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguageSettingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Data'),
              onTap: _clearSharedPreferences,
            ),
          ],
        ),
      ),
    );
  }
}
