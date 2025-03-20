import 'package:flutter/material.dart';

class TaskStatus {
  final int id;
  final String name;
  final Color color;

  TaskStatus({required this.id, required this.name, required this.color});

  static final availableStatus = {
    TaskStatus(id: 1, name: "Pending", color: Colors.grey),
    TaskStatus(id: 2, name: "In Progress", color: Colors.orange),
    TaskStatus(id: 3, name: "Completed", color: Colors.green),
  };
}
