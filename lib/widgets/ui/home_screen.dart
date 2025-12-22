import 'package:flutter/material.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 35,),
          onPressed: () {},
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              isRecording ? 'Encerrar Gravação' : 'Iniciar Gravação',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                changeRecord();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Icon(
                  isRecording ? Icons.stop_circle : Icons.fiber_manual_record,
                  color: Colors.red,
                  size: 200,
                ),
              ),
              splashColor: Colors.transparent,
              highlightColor: const Color.fromARGB(255, 243, 172, 172),
            ),
          ],
        ),
      ),
    );
  }

  void changeRecord() {
    setState(() {
      isRecording = !isRecording;
    });
  }
}
