import 'package:flutter/material.dart';

class RecordControl extends StatefulWidget {
  const RecordControl({super.key});

  @override
  State<RecordControl> createState() => _RecordControlState();
}

class _RecordControlState extends State<RecordControl> {
  bool isRecording = false;

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isRecording ? 'Encerrar Gravação' : 'Iniciar Gravação',
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: toggleRecording,
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
    );
  }
    void changeRecord() {
    setState(() {
      isRecording = !isRecording;
    });
  }
}
