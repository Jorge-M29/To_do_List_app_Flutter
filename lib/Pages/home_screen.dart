import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/Components/Card.dart';
import 'package:to_do_list_app/Components/taks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Taks> tasks = [];
  final TextEditingController _Controller = TextEditingController();

  Future<void> _addTask() async {
    final text = _Controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Taks(title: text, description: ''));
        _Controller.clear();
      });
    }
    await _saveTasks(); //Para guardar la tarea al agregarla
  }

  Future<void> removeTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });
    await _saveTasks(); //Para guardar la lista de tareas al eliminar una
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  //Cargar las tareas desde SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> taksList = json.decode(tasksJson);
      setState(() {
        tasks = taksList.map((task) => Taks.fromJson(task)).toList();
      });
    }
  }

  //Guardar las tareas en SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(
      tasks.map((task) => task.toJson()).toList(),
    );
    await prefs.setString('tasks', tasksJson);
  }

  //Para actualizar el estado de la tarea al marcarla como completada
  Future<void> _updateTaskCompletion(int index, bool? value) async {
    setState(() {
      tasks[index].isCompleted = value ?? false;

      //Reordenar la lista de tareas para que las completadas vayan al final
      tasks.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) {
          return 1; // a va después de b
        } else if (!a.isCompleted && b.isCompleted) {
          return -1; // a va antes de b
        }
        return 0; // mantienen el orden actual
      });
    });
    await _saveTasks(); //Guardar el estado actualizado de la tarea
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _Controller,
              decoration: InputDecoration(
                labelText: 'Add a new task',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text('No tasks added yet!'))
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          tittle: task.title,
                          isCompleted: task.isCompleted,
                          onDelete: () => removeTask(index),
                          onCheckboxChanged: (value) {
                            _updateTaskCompletion(index, value ?? false);
                          },
                        );
                      },
                      itemCount: tasks.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
