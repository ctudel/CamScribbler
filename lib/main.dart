import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'widgets/widgets.dart';
import 'models/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'My App',
        theme: theme,
        darkTheme: darkTheme,
        routes: routes,
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.title,
    required this.pageIndex,
    required this.child,
  });

  final String title;
  final int pageIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        body: child,
        bottomNavigationBar: MyNavBar(pageIndex: pageIndex),
      ),
    );
  }
}
