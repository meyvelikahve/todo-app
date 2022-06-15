import 'package:hive/hive.dart';

import '../models/task_model.dart';
import 'ı_local_storage.dart';

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<Task>('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTask = <Task>[];
    allTask = _taskBox.values.toList();

    if (allTask.isNotEmpty) {
      allTask.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
