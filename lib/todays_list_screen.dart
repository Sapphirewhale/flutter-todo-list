import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/auth_provider.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';
import 'package:tame_the_beast/repositories/todo_list_item_repository.dart';
import 'package:tame_the_beast/theme.dart';

class TodaysListScreen extends StatelessWidget {
  const TodaysListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Today's List"),
        TodaysProgressDisplay(),
        StreamBuilder<List<TodoListItem>>(
          stream: Get.find<TodoListItemRepository>()
              .getItems(Get.find<AuthProvider>().getUserId()),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  TodoListSection(
                      type: TodoListItemType.frequent,
                      items: snapshot.data!
                          .where((element) =>
                              element.type == TodoListItemType.frequent)
                          .toList()),
                  TodoListSection(
                      type: TodoListItemType.single,
                      items: snapshot.data!
                          .where((element) =>
                              element.type == TodoListItemType.single)
                          .toList()),
                  TodoListSection(
                      type: TodoListItemType.bonus,
                      items: snapshot.data!
                          .where((element) =>
                              element.type == TodoListItemType.bonus)
                          .toList()),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ),
      ],
    );
  }
}

class TodaysProgressDisplay extends StatefulWidget {
  const TodaysProgressDisplay({Key? key}) : super(key: key);

  @override
  State<TodaysProgressDisplay> createState() => _TodaysProgressDisplayState();
}

class _TodaysProgressDisplayState extends State<TodaysProgressDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TodoListItemDisplay extends StatelessWidget {
  final TodoListItem item;
  TodoListItemDisplay({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            item.title,
            style: item.isDone
                ? TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          Checkbox(
              value: item.isDone,
              onChanged: (val) {
                item.toggleTaskCompletion();
                Get.find<TodoListItemRepository>().saveItem(item);
              })
        ],
      ),
    );
  }
}

class TodoListTitleDisplay extends StatelessWidget {
  final TodoListItemType type;
  final int count;
  const TodoListTitleDisplay(
      {required this.type, required this.count, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: TTBTheme.transparentWhite,
              ),
              child: SizedBox(width: 100, child: Align(child: Text(type.name))),
            ),
            Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TTBTheme.transparentWhite,
                ),
                child: Text(count.toString())),
            InkWell(
              child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TTBTheme.transparentWhite,
                  ),
                  child: Text('+')),
              onTap: () => addTodoListItem(context),
            )
          ],
        ));
  }

  void addTodoListItem(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Todo List Item'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter a title'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Get.find<TodoListItemRepository>()
                        .saveItem(SingleTodoListItem(
                      title: controller.text,
                      appUserId: Get.find<AuthProvider>().getUserId(),
                    ));
                    Navigator.pop(context);
                  },
                  child: Text('Save')),
            ],
          );
        });
  }
}

class TodoListSection extends StatelessWidget {
  final TodoListItemType type;
  final List<TodoListItem> items;
  const TodoListSection({required this.type, required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TodoListTitleDisplay(type: type, count: items.length),
        for (var item in items.where((element) => !element.isDone))
          TodoListItemDisplay(item: item),
        for (var item in items.where((element) =>
            element.isDone &&
            element.completionDate!
                .isAfter(DateTime.now().subtract(Duration(days: 1)))))
          TodoListItemDisplay(item: item)
      ],
    );
  }
}
