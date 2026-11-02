import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read the saved theme BEFORE the first screen is drawn,
  // so the app never flashes the wrong theme.
  final prefs = SharedPreferencesAsync();
  final isDark = await prefs.getBool('isDark') ?? false;

  runApp(PocketNotesApp(startDark: isDark));
}

class PocketNotesApp extends StatefulWidget {
  final bool startDark;
  const PocketNotesApp({super.key, required this.startDark});

  @override
  State<PocketNotesApp> createState() => _PocketNotesAppState();
}

class _PocketNotesAppState extends State<PocketNotesApp> {
  late bool _isDark = widget.startDark;
  final _prefs = SharedPreferencesAsync();

  Future<void> _setDark(bool value) async {
    setState(() => _isDark = value);
    await _prefs.setBool('isDark', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Notes',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(isDark: _isDark, onThemeChanged: _setDark),
    );
  }
}
