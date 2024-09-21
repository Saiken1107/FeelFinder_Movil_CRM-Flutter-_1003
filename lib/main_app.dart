import 'package:feelfinder_mobile/app_theme.dart';
import 'package:feelfinder_mobile/views/screens/main_screen.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SQLiteHelper.createTables();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          // HorariosAsistencias.routeName: (context) => const HorariosAsistencias(),
        },
        localizationsDelegates: const [
          /*GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,*/
        ],
        supportedLocales: const [Locale('es')],
        theme: AppTheme(selectedColor: 0).theme(),
        //builder: EasyLoading.init(),
        home: const MainScreen());
  }
}
