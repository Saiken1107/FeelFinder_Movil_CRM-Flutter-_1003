import 'package:flutter/material.dart';

class QuejasPage extends StatefulWidget {
  const QuejasPage({super.key});

  @override
  State<QuejasPage> createState() => _QuejasPageState();
}

class _QuejasPageState extends State<QuejasPage> {
  void _refreshData() async {
    setState(() {
     
    });
  }
 
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Text("Ventas")
      )
    );
  }
}
