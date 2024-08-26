import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime dueDate;

  Task({required this.name, required this.dueDate});
}
