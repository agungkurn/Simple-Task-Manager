import 'package:flutter_submission_1/model/task_status.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime lastUpdate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.lastUpdate,
  });

  Task copy({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? lastUpdate,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    lastUpdate: lastUpdate ?? this.lastUpdate,
  );
}
