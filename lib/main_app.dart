import 'package:feelfinder_mobile/app_theme.dart';
import 'package:feelfinder_mobile/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SQLiteHelper.createTables();

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
        home: const Login());
  }
}
