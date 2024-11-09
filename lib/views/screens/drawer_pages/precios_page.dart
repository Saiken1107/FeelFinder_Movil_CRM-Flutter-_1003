import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../controllers/price_controller.dart';

class PreciosPage extends StatefulWidget {
  const PreciosPage({super.key});

  @override
  State<PreciosPage> createState() => _PreciosPageState();
}

class _PreciosPageState extends State<PreciosPage> {
  final _formKey = GlobalKey<FormState>();
  String _planType = '';
  double _planPrice = 0.0;
  String _company = '';
  int _licenseQuantity = 0;
  int _contractTime = 0;
  double _finalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    Provider.of<PriceController>(context, listen: false).fetchPrices();
  }

  void _savePrice() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPrice = {
        'id': DateTime.now().toString(),
        'planType': _planType,
        'planPrice': _planPrice,
        'company': _company,
        'licenseQuantity': _licenseQuantity,
        'contractTime': _contractTime,
        'finalPrice': _finalPrice,
      };
      Provider.of<PriceController>(context, listen: false).addPrice(newPrice);
    }
  }

  void _deletePrice(String id) {
    Provider.of<PriceController>(context, listen: false).deletePrice(id);
  }

  void _showAddPriceDialog() {
    final TextEditingController planTypeController = TextEditingController();
    final TextEditingController planPriceController = TextEditingController();
    final TextEditingController companyController = TextEditingController();
    final TextEditingController licenseQuantityController =
        TextEditingController();
    final TextEditingController contractTimeController =
        TextEditingController();
    final TextEditingController finalPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Precio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: planTypeController,
                decoration: const InputDecoration(labelText: 'Tipo de Plan'),
              ),
              TextField(
                controller: planPriceController,
                decoration: const InputDecoration(labelText: 'Precio del Plan'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Empresa'),
              ),
              TextField(
                controller: licenseQuantityController,
                decoration:
                    const InputDecoration(labelText: 'Cantidad Licencia'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: contractTimeController,
                decoration:
                    const InputDecoration(labelText: 'Tiempo de Contrato'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: finalPriceController,
                decoration: const InputDecoration(labelText: 'Precio Final'),
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
                final String planType = planTypeController.text;
                final double planPrice =
                    double.tryParse(planPriceController.text) ?? 0.0;
                final String company = companyController.text;
                final int licenseQuantity =
                    int.tryParse(licenseQuantityController.text) ?? 0;
                final int contractTime =
                    int.tryParse(contractTimeController.text) ?? 0;
                final double finalPrice =
                    double.tryParse(finalPriceController.text) ?? 0.0;
                final Map<String, dynamic> price = {
                  'id': UniqueKey().toString(),
                  'planType': planType,
                  'planPrice': planPrice,
                  'company': company,
                  'licenseQuantity': licenseQuantity,
                  'contractTime': contractTime,
                  'finalPrice': finalPrice,
                };
                _savePrice();
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
    final priceController = Provider.of<PriceController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Precios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPriceDialog,
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
                'Tabla de Precios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Tipo de Plan')),
                  DataColumn(label: Text('Precio del Plan')),
                  DataColumn(label: Text('Empresa')),
                  DataColumn(label: Text('Cantidad Licencia')),
                  DataColumn(label: Text('Tiempo de Contrato')),
                  DataColumn(label: Text('Precio Final')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: priceController.prices.map((price) {
                  return DataRow(cells: [
                    DataCell(Text(price['planType'])),
                    DataCell(Text('\$${price['planPrice']}')),
                    DataCell(Text(price['company'])),
                    DataCell(Text(price['licenseQuantity'].toString())),
                    DataCell(Text(price['contractTime'].toString())),
                    DataCell(Text('\$${price['finalPrice']}')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar el precio
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deletePrice(price['id']);
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Solicitud de Precio',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Tipo de Plan'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el tipo de plan';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planType = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Precio del Plan'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio del plan';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planPrice = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Empresa'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre de la empresa';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _company = value!;
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
                      decoration: const InputDecoration(
                          labelText: 'Tiempo de Contrato'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el tiempo de contrato';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contractTime = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Precio Final'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio final';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _finalPrice = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _savePrice,
                      child: const Text('Levantar Precio'),
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
