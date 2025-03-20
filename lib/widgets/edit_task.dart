import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task.dart';
import 'package:flutter_submission_1/model/task_status.dart';
import 'package:flutter_submission_1/shared/status_picker.dart';

class EditTask extends StatefulWidget {
  final Task existingData;

  const EditTask({super.key, required this.existingData});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late TaskStatus _status = widget.existingData.status;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingData.title;
    _descriptionController.text = widget.existingData.description;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) return;
      _onBackPressed(context, widget.existingData);
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(_titleController.value.text),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            _onBackPressed(context, widget.existingData);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _save(
            widget.existingData,
            _titleController.text,
            _descriptionController.text,
            _status,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
                textCapitalization: TextCapitalization.words,
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
                controller: _descriptionController,
                decoration: InputDecoration(hintText: "Description"),
                textCapitalization: TextCapitalization.sentences,
                minLines: 10,
                maxLines: null,
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

  void _save(
    Task existingData,
    String title,
    String description,
    TaskStatus status,
  ) {
    final now = DateTime.now();
    final data = existingData.copy(
      title: title,
      description: description,
      status: status,
      lastUpdate: now,
    );

    if (context.mounted) {
      Navigator.pop(context, data);
    }
  }

  void _onBackPressed(BuildContext context, Task existingData) async {
    final unchanged =
        _titleController.text == existingData.title &&
        _descriptionController.text == existingData.description &&
        _status == existingData.status;
    if (unchanged) {
      Navigator.pop(context);
      return;
    }

    final saveChanges = await _showUnsavedDialog();
    switch (saveChanges) {
      case true:
        _save(
          existingData,
          _titleController.text,
          _descriptionController.text,
          _status,
        );
        break;
      case false:
        if (context.mounted) Navigator.pop(context);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
