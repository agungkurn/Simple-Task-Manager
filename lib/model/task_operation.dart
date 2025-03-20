import 'package:flutter_submission_1/model/task.dart';

sealed class TaskOperation {
  final Task task;

  TaskOperation({required this.task});
}

class UpdateTask extends TaskOperation {
  UpdateTask({required super.task});
}

class DeleteTask extends TaskOperation {
  DeleteTask({required super.task});
}
