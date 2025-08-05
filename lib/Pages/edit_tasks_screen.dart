import 'package:flutter/material.dart';
import 'package:to_do_list_app/Components/taks.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
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
              // Aquí puedes agregar la lógica para editar la tarea
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
