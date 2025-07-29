import 'package:flutter/material.dart';

class Card extends StatefulWidget {
  const Card({super.key});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              value: false,
              onChanged: (value) {
                // Handle checkbox state change
              },
            ),
            SizedBox(width: 16),
            Text(
              'Task Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Handle delete action
              },
            ),
          ],
        ),
      ),
    );
  }
}
