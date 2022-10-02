import 'package:flutter/material.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';

class TodaysProgressDisplay extends StatelessWidget {
  List<TodoListItem> items;
  TodaysProgressDisplay({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<TodoListItemType, int> counts = {};
    for (TodoListItem item in items.where(
      (element) => element.isDone,
    )) {
      counts[item.type] = (counts[item.type] ?? 0) + 1;
    }
    bool first = true;
    List<Widget> children = [];
    for (TodoListItemType type in counts.keys) {
      bool last =
          type == counts.keys.where((element) => counts[element]! > 0).last &&
              items.where((element) => !element.isDone).isEmpty;
      if (counts[type]! > 0) {
        children.add(
          Expanded(
            flex: counts[type]!,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: first ? Radius.circular(30) : Radius.zero,
                    right: last ? Radius.circular(30) : Radius.zero),
                color: type.color,
              ),
            ),
          ),
        );
        first = false;
      }
    }
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...children,
          Expanded(
            flex: items.where((element) => !element.isDone).length,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: first ? Radius.circular(30) : Radius.zero,
                    right: Radius.circular(30)),
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
