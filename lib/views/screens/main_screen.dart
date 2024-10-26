import 'package:feelfinder_mobile/providers/drawer_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          context.watch<DrawerScreenProvider>().currentString,
        ),
        actions: const [],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.black12])),
        child: context.watch<DrawerScreenProvider>().currentScreen,
      ),
    );
  }
}
