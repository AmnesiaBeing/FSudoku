import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

// 设置页面，主要提供两个选项，是否自动填充，是否自动将唯一数字填上去
class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences Demo'),
      ),
      body: PreferencePage([
        PreferenceTitle('Theme(Unimplement)'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),
        PreferenceTitle('Sudoku'),
        SwitchPreference('Auto Fill', 'sudoku_autofill',
            desc: 'Auto fill the candidates at startup.'),
        SwitchPreference('Auto Number', 'sudoku_autonumber',
            desc: 'Auto select the only number.'),
        // SwitchPreference('Auto What?', 'sudoku_auto???',
        //     desc: 'I dont think so.'),
      ]),
    );
  }
}
