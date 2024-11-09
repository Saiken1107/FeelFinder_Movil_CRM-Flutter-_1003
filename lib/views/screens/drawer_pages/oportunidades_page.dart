// pages/opportunities_page.dart
import 'package:flutter/material.dart';
import '../../../models/Oportunidad.dart';

class OportunidadesPage extends StatefulWidget {
  const OportunidadesPage({super.key});

  @override
  _OpportunitiesPageState createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OportunidadesPage> {
  final List<Opportunity> _opportunities = [];

  void _addOpportunity(Opportunity opportunity) {
    setState(() {
      _opportunities.add(opportunity);
    });
  }

  void _editOpportunity(int index, Opportunity updatedOpportunity) {
    setState(() {
      _opportunities[index] = updatedOpportunity;
    });
  }

  void _deleteOpportunity(int index) {
    setState(() {
      _opportunities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oportunidades de Venta')),
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_opportunities[index].name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar acción para agregar nueva oportunidad
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
