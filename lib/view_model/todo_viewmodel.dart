import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_endpoints.dart';
import '../models/data_model.dart';
import '../presentation/bottom_sheet.dart';
import '../utils/app_strings.dart';

class TodoViewModel with ChangeNotifier {
  TodoViewModel({this.todoId});
  late final String? todoId;
  List<User> todos = [];

  getRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? 'unknown';
    var url = Uri.parse(ApiEndpoints.getTodo);
    var response = await http.get(url, headers: {'Device-id': deviceId});
    print(response.body.toString());
    final List data = jsonDecode(response.body);
    List<User> users = data.map((json) => User.fromJson(json)).toList();
    todos = users;
    notifyListeners();
  }

  deleteRequest(id) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? 'unknown';
    var url = Uri.parse("${ApiEndpoints.deleteTodo}$id");
    await http.delete(url, headers: {'Device-id': deviceId});
    return getRequest();
  }

  todoRequest(id) async {
    print(id);
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? 'unknown';
    if (id != null) {
      var url = Uri.parse("${ApiEndpoints.updateTodo}$id");
      await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'Device-id': deviceId},
        body: jsonEncode({
          'title': headingController.text.trim(),
          'description': noteController.text.trim(),
        }),
      );
      SnackBar(content: Text(kNoteUpdated));
    } else {
      var url = Uri.parse(ApiEndpoints.createTodo);
      await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Device-id': deviceId},
        body: jsonEncode([
          {
            'title': headingController.text.trim(),
            'description': noteController.text.trim(),
          },
        ]),
      );
      SnackBar(content: Text(kNoteAdded));
    }
    return getRequest();
  }
}

// todoRequest(todoID) async {
//   if (widget.todoId != null) {
//     var url = Uri.parse("${ApiEndpoints.updateTodo}$todoID");
//     await http.put(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'title': headingController.text.trim(),
//         'description': noteController.text.trim(),
//       }),
//     );
//    SnackBar(content: Text(kNoteUpdated));
//   } else {
//     var url = Uri.parse(ApiEndpoints.createTodo);
//     await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode([
//         {
//           'title': headingController.text.trim(),
//           'description': noteController.text.trim(),
//         },
//       ]),
//     );
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(kNoteAdded)));
//   }
//   return widget.requestFunction();
// }
