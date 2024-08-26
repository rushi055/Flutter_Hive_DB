import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskDialog({this.task, this.index});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _taskName = widget.task?.name ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _taskName,
              decoration: InputDecoration(labelText: 'Task Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task name';
                }
                return null;
              },
              onSaved: (value) => _taskName = value!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _dueDate.toLocal().toString().split(' ')[0],
              decoration: InputDecoration(labelText: 'Due Date'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  setState(() {
                    _dueDate = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text(widget.task == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskBox = Hive.box<Task>('tasks');

      if (widget.task == null) {
        taskBox.add(Task(name: _taskName, dueDate: _dueDate));
      } else {
        widget.task!.name = _taskName;
        widget.task!.dueDate = _dueDate;
        widget.task!.save();
      }

      Navigator.of(context).pop();
    }
  }
}
