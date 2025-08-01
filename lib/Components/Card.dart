import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String tittle;
  final VoidCallback onDelete;
  final bool isCompleted;
  final ValueChanged<bool?>? onCheckboxChanged;

  const TaskCard({
    super.key,
    required this.tittle,
    required this.onDelete,
    required this.isCompleted,
    this.onCheckboxChanged,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.all(6.0)),
            Checkbox(
              value: widget.isCompleted,
              onChanged: widget.onCheckboxChanged,
            ),
            SizedBox(width: 16),
            Text(
              widget.tittle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: widget.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: widget.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
