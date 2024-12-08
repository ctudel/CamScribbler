import 'package:cam_scribbler/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:provider/provider.dart';

import 'database/db.dart' as db;
import 'widgets/widgets.dart';
import 'models/models.dart';

void main() async {
  runApp(const MyApp());
  await db.init();
  // Debugging only, uncomment if needed
  // await db.deleteDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (ThemeData theme, ThemeData darkTheme) =>
          // Create providers at closest ancestor
          MultiProvider(
        providers: [
          ChangeNotifierProvider<CanvasProvider>(
              create: (_) => CanvasProvider()),
          ChangeNotifierProvider<SettingsProvider>(
              create: (_) => SettingsProvider()),
        ],
        child: MaterialApp(
          title: 'My App',
          theme: theme,
          darkTheme: darkTheme,
          onGenerateRoute: (RouteSettings settings) => genRoutes(settings),
          routes: routes,
        ),
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
        appBar: AppBar(
          title: Text(title),
        ),
        body: child,
        bottomNavigationBar: MyNavBar(pageIndex: pageIndex),
      ),
    );
  }
}
