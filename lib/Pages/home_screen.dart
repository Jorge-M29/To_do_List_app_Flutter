import 'package:flutter/material.dart';
import 'package:to_do_list_app/Components/taks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Taks> tasks = [];
  final TextEditingController _Controller = TextEditingController();

  void _addTask() {
    final text = _Controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Taks(title: text, description: ''));
        _Controller.clear();
      });
    }
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
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
                        return Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: task.description.isNotEmpty
                                ? Text(task.description)
                                : null,
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeTask(index),
                            ),
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  task.isCompleted = value ?? false;
                                });
                              },
                            ),
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
}
