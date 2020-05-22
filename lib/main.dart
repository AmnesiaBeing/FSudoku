import 'package:flutter/material.dart';
import 'package:fsudoku/ui/pageMain.dart';
import 'package:fsudoku/ui/pagePreferences.dart';
import 'package:preferences/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({
    'ui_theme': 'light',
    'sudoku_autofill': true,
    'sudoku_autonumber': true
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SudokuPage(),
        '/preferences': (context) => PreferencesPage()
      },
    );
  }
}
