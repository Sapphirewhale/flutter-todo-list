import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/auth_provider.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';
import 'package:tame_the_beast/repositories/todo_list_item_repository.dart';
import 'package:tame_the_beast/widgets/todays_progress_bar.dart';
import 'package:tame_the_beast/widgets/todo_list_section.dart';

class TodaysListScreen extends StatelessWidget {
  const TodaysListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<TodoListItem>>(
            stream: Get.find<TodoListItemRepository>()
                .getTodaysItems(Get.find<AuthProvider>().getUserId()),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      TodaysProgressDisplay(items: snapshot.data!),
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
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
      ],
    );
  }
}
