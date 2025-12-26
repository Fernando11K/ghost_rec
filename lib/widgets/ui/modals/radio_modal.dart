import 'package:flutter/material.dart';

Future<void> showRadioModal({
  required BuildContext context,
  required String title,
  required String value,
  required Map<String, String> options,
  required ValueChanged<String> onChanged,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: RadioGroup<String>(
          groupValue: value,
          onChanged: (v) {
            onChanged(v!);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.entries
                .map(
                  (e) => RadioListTile<String>(
                    value: e.key,
                    title: Text(
                      e.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    },
  );
}
