import 'package:flutter/material.dart';

class DurationVideoDialog extends StatefulWidget {
  final double initialvalue;

  const DurationVideoDialog({super.key, required this.initialvalue});

  @override
  State<DurationVideoDialog> createState() => _DurationVideoDialogState();
}

class _DurationVideoDialogState extends State<DurationVideoDialog> {
  late double _durationTemp;

  @override
  void initState() {
    super.initState();
    _durationTemp = widget.initialvalue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Duração do vídeo',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_durationTemp.round()} min',
            style: const TextStyle(fontSize: 16),
          ),
          Slider(
            value: _durationTemp,
            min: 1,
            max: 60,
            divisions: 59,
            label: '${_durationTemp.round()} min',
            onChanged: (v) {
              setState(() {
                _durationTemp = v;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _durationTemp),
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
