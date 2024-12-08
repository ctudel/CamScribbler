import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cam_scribbler/providers/providers.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);
    final bool isLight =
        AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    final bool isGrid = provider.isGrid;
    final int coloredPhotos = provider.coloredPhotos ?? 0;
    print(provider.coloredPhotos);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Appearance'),
                IconButton(
                  icon: isLight
                      ? PhosphorIcon(PhosphorIcons.sunHorizon())
                      : PhosphorIcon(PhosphorIcons.moonStars()),
                  style: IconButton.styleFrom(
                    backgroundColor: (isLight) ? Colors.amber : Colors.black26,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isLight)
                        AdaptiveTheme.of(context).setDark();
                      else
                        AdaptiveTheme.of(context).setLight();
                      print(AdaptiveTheme.of(context).mode);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Colored Photos'),
                const SizedBox(width: 10),
                Switch(
                  value: coloredPhotos == 0,
                  activeColor: Colors.amber,
                  onChanged: (bool value) {
                    setState(() {
                      print(value);
                      final int tVal =
                          (value) ? 0 : 1; // if not enabled, enable
                      print('tVal: $tVal');
                      provider.setRgb(tVal);
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text('Drawing Gallery View'),
            Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: (isGrid) ? Colors.amber : Colors.black12,
                    foregroundColor: (isGrid)
                        ? Colors.black
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  icon: PhosphorIcon(PhosphorIcons.gridFour()),
                  onPressed: () {
                    setState(() {
                      provider.setGrid();
                    });
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: (!isGrid) ? Colors.amber : Colors.black12,
                    foregroundColor: (!isGrid)
                        ? Colors.black
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  icon: PhosphorIcon(PhosphorIcons.images()),
                  onPressed: () {
                    setState(() {
                      provider.setCarousel();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
