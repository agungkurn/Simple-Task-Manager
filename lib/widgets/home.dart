import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task.dart';
import 'package:flutter_submission_1/model/task_operation.dart';
import 'package:flutter_submission_1/model/task_status.dart';
import 'package:flutter_submission_1/widgets/create_task.dart';
import 'package:flutter_submission_1/widgets/task_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tasks = List<Task>.empty(growable: true);
  TaskStatus? filteredStatus;

  @override
  Widget build(BuildContext context) {
    final filtered =
        tasks.where((task) {
          return filteredStatus == null
              ? true
              : task.status.id == filteredStatus?.id;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Simple Task Manager")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () async {
          final newTask = await _createTask(context);
          setState(() {
            if (newTask != null) tasks.add(newTask);
          });
        },
      ),
      body: Column(
        children: [
          if (tasks.isNotEmpty)
            statusFilter(TaskStatus.availableStatus.toList()),
          Expanded(
            child:
                filtered.isEmpty
                    ? emptyTasks(filteredStatus)
                    : taskList(filtered),
          ),
        ],
      ),
    );
  }

  Widget statusFilter(List<TaskStatus> availableStatus) =>
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 8,
            children:
                availableStatus
                    .map(
                      (status) => ChoiceChip(
                        selectedColor: status.color,
                        label: Text(status.name),
                        selected: status.id == filteredStatus?.id,
                        onSelected: (selected) {
                          setState(() {
                            filteredStatus = selected ? status : null;
                          });
                        },
                      ),
                    )
                    .toList(),
          ),
        ),
      );

  Widget emptyTasks(TaskStatus? status) => Center(
    child: Text(
      status == null
          ? "No tasks yet."
          : "No tasks with status ${status.name} yet.",
    ),
  );

  Widget taskList(List<Task> displayTasks) => ListView.builder(
    padding: EdgeInsets.all(16),
    itemCount: displayTasks.length,
    itemBuilder: (context, i) {
      final task = displayTasks[i];

      return Card(
        child: InkWell(
          onTap: () async {
            final operation = await _openTaskDetails(context, task);

            if (operation is UpdateTask) {
              final index = displayTasks.indexWhere(
                (task) => task.id == operation.task.id,
              );
              if (index != -1) {
                setState(() {
                  tasks[index] = operation.task;
                });
              }
            } else if (operation is DeleteTask) {
              setState(() {
                tasks.removeWhere((task) => task.id == operation.task.id);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  task.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      color: task.status.color,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        task.status.name,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Future<TaskOperation?> _openTaskDetails(
    BuildContext context,
    Task task,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetails(task: task)),
    );

    if (!context.mounted) return null;

    return result is TaskOperation ? result : null;
  }

  Future<Task?> _createTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTask()),
    );

    if (!context.mounted) return null;

    return result is Task ? result : null;
  }
}
