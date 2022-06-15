import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/main.dart';
import '../data/ı_local_storage.dart';
import '../models/task_model.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            'Yapılacaklar Listesi',
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
        onPressed: () {
          _showAddTaskBottomSheet();
        },
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var currentValue = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Görevi Sil')
                    ],
                  ),
                  key: Key(currentValue.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: currentValue);
                    setState(() {});
                  },
                  child: TaskItem(task: currentValue),
                );
              },
              itemCount: _allTasks.length,
            )
          : const Center(
              child: Text('Yeni görev ekle.'),
            ),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Görev ekle.',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context, showSecondsColumn: false,
                      onConfirm: (time) async {
                    var yeniEklenecekGorev =
                        Task.create(name: value, createdAt: time);

                    _allTasks.insert(0, yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDb();
  }
}
