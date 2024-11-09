// pages/opportunities_page.dart
import 'package:flutter/material.dart';
import '../../../models/oportunidad.dart';

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

  void _showAddOpportunityDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController probabilityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Oportunidad de Venta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: probabilityController,
                decoration:
                    const InputDecoration(labelText: 'Probabilidad (%)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String name = nameController.text;
                final double probability =
                    double.tryParse(probabilityController.text) ?? 0.0;
                final Opportunity opportunity =
                    Opportunity(name: name, probability: probability);
                _addOpportunity(opportunity);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_opportunities[index].name),
            subtitle:
                Text('Probabilidad: ${_opportunities[index].probability}%'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implementar la edición de la oportunidad
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteOpportunity(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOpportunityDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Opportunity {
  final String name;
  final double probability;

  Opportunity({required this.name, required this.probability});
}
