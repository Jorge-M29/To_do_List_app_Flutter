import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/Components/Card.dart';
import 'package:to_do_list_app/Components/taks.dart';
import 'package:to_do_list_app/Pages/edit_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  final TextEditingController _Controller = TextEditingController();

  Future<void> _addTask() async {
    final text = _Controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: text, description: ''));
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
      final List<dynamic> TaskList = json.decode(tasksJson);
      setState(() {
        tasks = TaskList.map((task) => Task.fromJson(task)).toList();
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
                        //Navegación hacia la card
                        return GestureDetector(
                          onTap: () {
                            navigation_and_animation(context, task, index);
                          },
                          //Card para mostrar la tarea
                          child: TaskCard(
                            tittle: task.title,
                            isCompleted: task.isCompleted,
                            onDelete: () => removeTask(index),
                            onCheckboxChanged: (value) {
                              _updateTaskCompletion(index, value ?? false);
                            },
                          ),
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

  Future<void> navigation_and_animation(
    BuildContext context,
    Task task,
    int index,
  ) async {
    final updatedTask = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditTaskScreen(task: task),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        tasks[index] = updatedTask;
      });
      await _saveTasks(); //Guardar la tarea actualizada
    }
  }
}
