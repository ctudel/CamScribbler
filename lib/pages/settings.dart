import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _autoSave = false;
  bool _grid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 30.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Appearance'),
                Switch(
                  value:
                      AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light,
                  activeColor: Colors.amber,
                  onChanged: (bool value) {
                    if (value)
                      AdaptiveTheme.of(context).setLight();
                    else
                      AdaptiveTheme.of(context).setDark();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Auto Save'),
                Switch(
                  value: _autoSave,
                  activeColor: Colors.amber,
                  onChanged: (bool value) {
                    setState(() {
                      _autoSave = value;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Grid View'),
                Switch(
                  value: _grid,
                  activeColor: Colors.amber,
                  onChanged: (bool value) {
                    setState(() {
                      _grid = value;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
