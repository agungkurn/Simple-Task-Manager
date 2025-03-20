import 'package:flutter/material.dart';
import 'package:flutter_submission_1/model/task_status.dart';

class StatusPickerScreen extends StatelessWidget {
  final TaskStatus selected;

  const StatusPickerScreen({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task status"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children:
            TaskStatus.availableStatus
                .map(
                  (item) => InkWell(
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name),
                          if (selected == item) Icon(Icons.check),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
