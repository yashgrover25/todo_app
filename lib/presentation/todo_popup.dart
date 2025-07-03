import 'package:flutter/material.dart';
import 'package:todo_app/utils/app_strings.dart';

class ReadOnlyPopup extends StatelessWidget {
  final String heading;
  final String note;

  const ReadOnlyPopup({
    super.key,
    required this.heading,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                kTodoDetails,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text("$kHeading:\n$heading", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text("$kNote:\n$note", style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(), // or remove Overlay
                  child: const Text(kClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
