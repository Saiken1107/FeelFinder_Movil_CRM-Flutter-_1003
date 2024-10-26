import 'package:feelfinder_mobile/main_app.dart';
import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await _initHive();


  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => DrawerScreenProvider(),
    child: const MainApp(),
  ));
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}