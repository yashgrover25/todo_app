import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/app_strings.dart';

import '../view_model/todo_viewmodel.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({
    super.key,
    required this.todoViewModel,
    this.initialHeading,
    this.initialNote,
    this.todoId,
  });
  final String? initialHeading;
  final String? initialNote;
  final String? todoId;
  final todoViewModel;

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

TextEditingController headingController = TextEditingController();
TextEditingController noteController = TextEditingController();

class _MyBottomSheetState extends State<MyBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    headingController = TextEditingController(text: widget.initialHeading);
    noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    headingController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final todoViewModel = Provider.of<TodoViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter your Todo Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Heading';
                        }
                        return null;
                      },
                      controller: headingController,
                      decoration: InputDecoration(
                        hintText: kHeading,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: noteController,
                      maxLines: 7,
                      decoration: InputDecoration(
                        hintText: kYourNote,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                            widget.todoViewModel.todoRequest(widget.todoId);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                        }
                      },
                      child: const Text(
                        kSave,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
