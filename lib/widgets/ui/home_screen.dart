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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.black,
        // Here we take the value from the HomeScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        //leading: IconButton(icon: const Icon(Icons.more_vert, color: Colors.white, size: 35,),onPressed: () {},),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 35),
          offset: const Offset(0, 55),

          onSelected: (value) {
            print(value);
            // Aqui você trata a ação de cada item
            if (value == 'settings') {
              // Exemplo: abrir configurações
              Navigator.pushNamed(context, "/settings");
            } else if (value == 'recordings') {
              // Exemplo: mostrar info
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
