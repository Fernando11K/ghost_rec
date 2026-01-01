import 'package:flutter/material.dart';
import 'package:ghost_rec/widgets/ui/home_screen.dart';
import 'package:ghost_rec/widgets/ui/lock_screen.dart';
import 'package:ghost_rec/widgets/ui/settings_screen.dart';

void main() {
  runApp(const GhostRecApp());
}

class GhostRecApp extends StatelessWidget {
  const GhostRecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => LockScreen(child: const HomeScreen()),

        "/settings": (context) => const SettingsScreen(),
      },
      initialRoute: "/",
    );
  }
}
