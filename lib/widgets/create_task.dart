import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task.dart';
import 'package:flutter_submission_1/model/task_status.dart';
import 'package:flutter_submission_1/shared/status_picker.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  var _title = "";
  var _description = "";
  var _status = TaskStatus.availableStatus.first;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) return;
      _onBackPressed(context);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            _onBackPressed(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => _save(_title, _description, _status),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _title = value;
                },
              ),
              SizedBox(height: 16),
              statusPicker(
                context: context,
                selected: _status,
                items: TaskStatus.availableStatus,
                onSelected: (status) {
                  setState(() {
                    _status = status;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(hintText: "Description"),
                textCapitalization: TextCapitalization.sentences,
                minLines: 10,
                maxLines: null,
                onChanged: (value) {
                  _description = value;
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<bool?> _showUnsavedDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Save changes?"),
        content: Text("Save the changes you've made or discard it"),
        actions: [
          TextButton(
            child: Text("Save"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: Text("Discard"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );

  void _save(String title, String description, TaskStatus status) {
    final now = DateTime.now();
    final data = Task(
      id: now.millisecondsSinceEpoch,
      title: title,
      description: description,
      status: status,
      lastUpdate: now,
    );

    if (context.mounted) {
      Navigator.pop(context, data);
    }
  }

  void _onBackPressed(BuildContext context) async {
    if (_title.isEmpty && _description.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final saveChanges = await _showUnsavedDialog();
    switch (saveChanges) {
      case true:
        _save(_title, _description, _status);
        break;
      case false:
        if (context.mounted) Navigator.pop(context);
        break;
      default:
        break;
    }
  }
}
