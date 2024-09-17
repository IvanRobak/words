import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:words/providers/button_provider.dart';
// import 'package:words/providers/image_progress_provider.dart';
import 'package:words/providers/theme_provider.dart';
// import 'package:words/providers/word_progress_provider.dart';
// import 'package:words/providers/favorite_provider.dart';
// import 'package:words/providers/write_progress_provider.dart';
import 'package:words/screens/settiings/about_screen.dart';
import 'package:words/screens/settiings/auth_screen.dart';
import 'package:words/screens/settiings/language_screen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
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

  Future<void> _confirmAndClearCache() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirm Clear Cache',
          ),
          content: const Text('Are you sure you want to clear the cache?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldClear == true) {
      await _clearCache();
    }
  }

  Future<void> _clearCache() async {
    await DefaultCacheManager().emptyCache();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Перевіряємо, чи віджет все ще "підключений" до дерева після асинхронних операцій
    if (!mounted) return;

    // Попередній Navigator.pop для закриття поточного діалогового вікна
    Navigator.of(context).pop();

    // Показуємо повідомлення про успішне очищення кешу
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Cache Cleared',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text(
            'Cache has been successfully cleared.',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
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
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, theme) {
        final isDarkMode = theme.brightness == Brightness.dark;

        return Theme(
          data: theme.copyWith(
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
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
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
                            fontWeight: soundEnabled
                                ? FontWeight.bold
                                : FontWeight.normal,
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
                            fontWeight: !soundEnabled
                                ? FontWeight.bold
                                : FontWeight.normal,
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
                          context.read<ThemeBloc>().add(ThemeEvent.toggle);
                        },
                        child: Text(
                          isDarkMode ? 'Dark' : 'Light',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.white,
                            fontWeight: isDarkMode
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
                            builder: (context) =>
                                const LanguageSettingsScreen()));
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
                  title: const Text('Clear Cache'),
                  onTap: _confirmAndClearCache,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
