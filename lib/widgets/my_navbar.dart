import 'package:flutter/material.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Drawings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (idx) {
        // TODO: Add pages as they are implemented
        Navigator.of(context).pushReplacementNamed(
          switch (idx) {
            0 => '/',
            1 => '/drawings',
            2 => '/settings',
            _ => '/',
          },
        );
      },
    );
  }
}
