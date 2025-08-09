import 'package:flutter/material.dart';
import 'package:to_do_list_app/Components/taks.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newTitle = _titleController.text.trim();
                if (newTitle.isNotEmpty) {
                  Navigator.of(context).pop(newTitle);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    ).then((newTitle) {
      if (newTitle != null && newTitle.isNotEmpty) {
        setState(() {
          widget.task.title = newTitle;
        });
        Navigator.pop(context, widget.task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.task.title)),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(widget.task.description),
      ), // Mostrar el título de la tarea
    );
  }
}
