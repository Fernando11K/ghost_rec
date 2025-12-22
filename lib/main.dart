import 'package:flutter/material.dart';
import 'package:ghost_rec/widgets/ui/home_screen.dart';
import 'package:ghost_rec/widgets/ui/settings_screen.dart';


void main() {
  runApp(const GhostRecApp());
}

class GhostRecApp extends StatelessWidget {
  const GhostRecApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(      

      routes: {
        "/": (context) => const HomeScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
      initialRoute: "/",
    );
  }
}
