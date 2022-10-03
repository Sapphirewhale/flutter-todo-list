import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/widgets/new_todo_list_item_display.dart';

import '../auth_provider.dart';
import '../models/todo_list_item.dart';
import '../repositories/todo_list_item_repository.dart';
import '../theme.dart';

class TodoListSection extends StatelessWidget {
  final TodoListItemType type;
  final List<TodoListItem> items;
  const TodoListSection({required this.type, required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Column(
      children: [
        TodoListTitleDisplay(type: type, count: items.length),
        for (var item in items.where((element) => !element.isDone))
          TodoListItemDisplay(item: item),
        for (var item in items.where((element) =>
            element.isDone &&
            element.completionDate!
                .isAfter(DateTime(now.year, now.month, now.day))))
          TodoListItemDisplay(item: item)
      ],
    );
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

  void addTodoListItem(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return NewTodoListItemDisplay(
            initialType: type,
          );
        });
  }

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
}
