import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tame_the_beast/models/todo_list_item.dart';

class TodoListItemRepository {
  FirebaseFirestore firebase = Get.find<FirebaseFirestore>();

  void saveItem(TodoListItem item) async {
    if (item.id == '') {
      var docRef = await firebase
          .collection('users')
          .doc(item.appUserId)
          .collection('todoListItems')
          .add(item.toMap());
      item.id = docRef.id;
    }
    firebase
        .collection('users')
        .doc(item.appUserId)
        .collection('todoListItems')
        .doc(item.id)
        .set(item.toMap());
  }

  Future<TodoListItem> getItem(String userId, String id) async {
    return TodoListItem.fromMap((await firebase
            .collection('users')
            .doc(userId)
            .collection('todoListItems')
            .doc(id)
            .get())
        .data()!);
  }

  Stream<List<TodoListItem>> getTodaysItems(String userId) {
    DateTime now = DateTime.now();
    return firebase
        .collection('users')
        .doc(userId)
        .collection('todoListItems')
        .snapshots()
        .map((event) => event.docs
            .map((e) => TodoListItem.fromMap(e.data()))
            .where((element) => (element.completionDate == null ||
                element.completionDate!
                        .isAfter(DateTime(now.year, now.month, now.day)) &&
                    element.startDate.isBefore(DateTime.now())))
            .toList(growable: false));
  }
}
