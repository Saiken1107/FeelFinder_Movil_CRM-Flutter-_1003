import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/controllers/quote_controller.dart';

class CotizacionesPage extends StatefulWidget {
  const CotizacionesPage({super.key});

  @override
  State<CotizacionesPage> createState() => _CotizacionesPageState();
}

class _CotizacionesPageState extends State<CotizacionesPage> {
  final _formKey = GlobalKey<FormState>();
  String _clientName = '';
  int _licenseQuantity = 0;
  String _planType = '';
  double _planPrice = 0.0;

  @override
  void initState() {
    super.initState();
    Provider.of<QuoteController>(context, listen: false).fetchQuotes();
  }

  void _saveQuote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newQuote = {
        'id': DateTime.now().toString(),
        'clientName': _clientName,
        'licenseQuantity': _licenseQuantity,
        'planType': _planType,
        'planPrice': _planPrice,
      };
      Provider.of<QuoteController>(context, listen: false).addQuote(newQuote);
    }
  }

  void _deleteQuote(String id) {
    Provider.of<QuoteController>(context, listen: false).deleteQuote(id);
  }

  void _showAddQuoteDialog() {
    final TextEditingController clientController = TextEditingController();
    final TextEditingController licenseQuantityController =
        TextEditingController();
    final TextEditingController planTypeController = TextEditingController();
    final TextEditingController planPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Cotización'),
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
                controller: planTypeController,
                decoration: const InputDecoration(labelText: 'Tipo de Plan'),
              ),
              TextField(
                controller: planPriceController,
                decoration: const InputDecoration(labelText: 'Precio del Plan'),
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
                final String clientName = clientController.text;
                final int licenseQuantity =
                    int.tryParse(licenseQuantityController.text) ?? 0;
                final String planType = planTypeController.text;
                final double planPrice =
                    double.tryParse(planPriceController.text) ?? 0.0;
                final Map<String, dynamic> quote = {
                  'id': UniqueKey().toString(),
                  'clientName': clientName,
                  'licenseQuantity': licenseQuantity,
                  'planType': planType,
                  'planPrice': planPrice,
                };
                _saveQuote();
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
    final quoteController = Provider.of<QuoteController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddQuoteDialog,
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
                'Tabla de Cotizaciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Cantidad Licencia')),
                  DataColumn(label: Text('Tipo de Plan')),
                  DataColumn(label: Text('Precio del Plan')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: quoteController.quotes.map((quote) {
                  return DataRow(cells: [
                    DataCell(Text(quote['clientName'])),
                    DataCell(Text(quote['licenseQuantity'].toString())),
                    DataCell(Text(quote['planType'])),
                    DataCell(Text('\$${quote['planPrice']}')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Lógica para editar la cotización
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteQuote(quote['id']);
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Solicitud de Cotización',
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveQuote,
                      child: const Text('Levantar Cotización'),
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
