import 'package:flutter/material.dart';
import 'package:todo_app/widgets/task_list_item.dart';
import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemBuilder: (context, index) {
              var currentValue = filteredList[index];
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
                    Text('Görevi Sil'),
                  ],
                ),
                key: Key(currentValue.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);

                  //await locator<LocalStorage>().deleteTask(task: currentValue);
                },
                child: TaskItem(task: currentValue),
              );
            },
            itemCount: filteredList.length,
          )
        : const Center(
            child: Text('Görev bulunamadı.'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
