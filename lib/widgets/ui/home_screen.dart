import 'package:flutter/material.dart';
import 'package:ghost_rec/widgets/ui/record_control.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "👻 GhostRec";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icon/ghostrec_logo.png', height: 35),
            const SizedBox(width: 8),
            const Text('GhostRec', style: TextStyle(color: Colors.white)),
          ],
        ),

        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 35),
          offset: const Offset(0, 55),

          onSelected: (value) {
            if (value == 'settings') {
              Navigator.pushNamed(context, "/settings");
            } else if (value == 'recordings') {
              print('Informações selecionadas');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.black),
                title: Text('Configurações'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'recordings',
              child: ListTile(
                leading: Icon(Icons.folder, color: Colors.black),
                title: Text('Gravações'),
              ),
            ),
          ],
        ),
      ),
      body: const RecordControl(),
    );
  }
}
