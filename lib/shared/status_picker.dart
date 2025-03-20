import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task_status.dart';
import 'package:flutter_submission_1/status_picker.dart';

Widget statusPicker({
  required BuildContext context,
  required TaskStatus selected,
  required Set<TaskStatus> items,
  required void Function(TaskStatus) onSelected,
}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("Status"),
    OutlinedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(selected.color),
      ),
      child: Text(selected.name),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatusPickerScreen(selected: selected),
          ),
        );

        if (!context.mounted) return;

        if (result is TaskStatus) {
          onSelected(result);
        }
      },
    ),
  ],
);
