import 'package:flutter/material.dart';
import 'package:flutter_hive_db/task_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No tasks available.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Task task = box.getAt(index)!;
              return ListTile(
                title: Text(task.name),
                subtitle: Text('Due: ${task.dueDate.toLocal()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editTask(context, box, task, index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => box.deleteAt(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(),
    );
  }

  void _editTask(BuildContext context, Box<Task> box, Task task, int index) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(task: task, index: index),
    );
  }
}
