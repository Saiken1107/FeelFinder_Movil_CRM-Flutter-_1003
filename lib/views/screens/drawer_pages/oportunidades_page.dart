import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../controllers/opportunity_controller.dart';

class OportunidadesPage extends StatefulWidget {
  const OportunidadesPage({super.key});

  @override
  State<OportunidadesPage> createState() => _OportunidadesPageState();
}

class _OportunidadesPageState extends State<OportunidadesPage> {
  final _formKey = GlobalKey<FormState>();
  String _clientName = '';
  int _licenseQuantity = 0;
  String _status = '';

  @override
  void initState() {
    super.initState();
    Provider.of<OpportunityController>(context, listen: false)
        .fetchOpportunities();
  }

  void _saveOpportunity() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newOpportunity = {
        'id': DateTime.now().toString(),
        'clientName': _clientName,
        'licenseQuantity': _licenseQuantity,
        'status': _status,
      };
      Provider.of<OpportunityController>(context, listen: false)
          .addOpportunity(newOpportunity);
    }
  }

  void _deleteOpportunity(String id) {
    Provider.of<OpportunityController>(context, listen: false)
        .deleteOpportunity(id);
  }

  void _showAddOpportunityDialog() {
    final TextEditingController clientController = TextEditingController();
    final TextEditingController licenseQuantityController =
        TextEditingController();
    final TextEditingController statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Oportunidad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clientController,
                decoration: const InputDecoration(labelText: 'Cliente'),
              ),
              TextField(
                controller: licenseQuantityController,
                decoration:
                    const InputDecoration(labelText: 'Cantidad Licencia'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
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
                final String clientName = clientController.text;
                final int licenseQuantity =
                    int.tryParse(licenseQuantityController.text) ?? 0;
                final String status = statusController.text;
                final Map<String, dynamic> opportunity = {
                  'id': UniqueKey().toString(),
                  'clientName': clientName,
                  'licenseQuantity': licenseQuantity,
                  'status': status,
                };
                _saveOpportunity();
                Navigator.of(context).pop();
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final opportunityController = Provider.of<OpportunityController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunidades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddOpportunityDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tabla de Oportunidades',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Cantidad Licencia')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: opportunityController.opportunities.map((opportunity) {
                  return DataRow(cells: [
                    DataCell(Text(opportunity['clientName'])),
                    DataCell(Text(opportunity['licenseQuantity'].toString())),
                    DataCell(Text(opportunity['status'])),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar la oportunidad
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteOpportunity(opportunity['id']);
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Solicitud de Oportunidad',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del cliente';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _clientName = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Cantidad Licencia'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la cantidad de licencias';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _licenseQuantity = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Status'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el status';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _status = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveOpportunity,
                      child: const Text('Levantar Oportunidad'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
