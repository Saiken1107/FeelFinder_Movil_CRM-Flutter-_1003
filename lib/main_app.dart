import 'package:feelfinder_mobile/app_theme.dart';
import 'package:feelfinder_mobile/views/screens/login.dart';
import 'package:feelfinder_mobile/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SQLiteHelper.createTables();
    final box = Hive.box('login');
    final token = box.get('token');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          //Estas rutas son para las pantallas que no estan en el drawer
          // HorariosAsistencias.routeName: (context) => const HorariosAsistencias(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        theme: AppTheme(selectedColor: 0).theme(),
        builder: EasyLoading.init(),
        home: token != null ? const MainScreen() : const Login());
  }
}
