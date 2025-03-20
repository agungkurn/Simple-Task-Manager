import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task_operation.dart';
import 'package:flutter_submission_1/model/task_status.dart';
import 'package:flutter_submission_1/shared/status_picker.dart';
import 'package:flutter_submission_1/widgets/edit_task.dart';

import '../model/task.dart';

class TaskDetails extends StatefulWidget {
  final Task task;

  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late Task currentTask = widget.task;
  TaskOperation? _operation;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      _onBackPressed(context);
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onBackPressed(context),
        ),
        title: Text(currentTask.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final newTask = await _editTask(context, currentTask);
              if (newTask != null && context.mounted) {
                _operation = UpdateTask(task: newTask);

                setState(() {
                  currentTask = newTask;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete Confirmation"),
                    content: Text("Delete task ${currentTask.title}?"),
                    actions: [
                      TextButton(
                        child: Text("Delete"),
                        onPressed: () {
                          Navigator.pop(context);
                          _operation = DeleteTask(task: currentTask);
                          _onBackPressed(context);
                        },
                      ),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              statusPicker(
                context: context,
                selected: currentTask.status,
                items: TaskStatus.availableStatus,
                onSelected: (status) {
                  setState(() {
                    currentTask = currentTask.copy(status: status);
                  });
                  _operation = UpdateTask(task: currentTask);
                },
              ),
              Text(currentTask.description),
              Container(
                margin: EdgeInsets.only(top: 64),
                child: Text(
                  "Last updated: ${currentTask.lastUpdate.toString()}",
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<Task?> _editTask(BuildContext context, Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTask(existingData: task)),
    );

    if (!context.mounted) return null;

    return result is Task ? result : null;
  }

  void _onBackPressed(BuildContext context) {
    Navigator.pop(context, _operation);
  }
}
