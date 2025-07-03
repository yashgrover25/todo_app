import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/presentation/homescreen.dart';
import 'package:todo_app/view_model/todo_viewmodel.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  const deviceIdKey = 'device_id';
  String? deviceId = prefs.getString(deviceIdKey);

  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await prefs.setString(deviceIdKey, deviceId);
    print('🆕 Device ID generated: $deviceId');
  } else {
    print('🔁 Device ID exists: $deviceId');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => TodoViewModel(),
        child: const HomeScreen(),
      ),
    );
  }
}
