import 'dart:io';

import 'package:feelfinder_mobile/main_app.dart';
import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


class HttpOverridesHelper extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await _initHive();

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = HttpOverridesHelper();
  
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
