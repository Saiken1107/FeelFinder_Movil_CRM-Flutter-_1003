import 'package:flutter/material.dart';
//import 'package:feel_finder_movil_1003-main/lib/models/quote_model.dart';
import 'package:feelfinder_mobile/models/quote_model.dart';

class CotizacionesPage extends StatefulWidget {
  const CotizacionesPage({super.key});

  @override
  State<CotizacionesPage> createState() => _CotizacionesPageState();
}

class _CotizacionesPageState extends State<CotizacionesPage> {
  final _formKey = GlobalKey<FormState>();
  String _productLicense = '';
  int _quantity = 0;
  double _price = 0.0;
  String _clientName = '';
  final List<Quote> _quotes = [];

  void _saveQuote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newQuote = Quote(
        id: DateTime.now().toString(),
        productLicense: _productLicense,
        quantity: _quantity,
        price: _price,
        clientName: _clientName,
      );
      setState(() {
        _quotes.add(newQuote);
      });
    }
  }

  void _refreshData() async {
    setState(() {
      // Actualización de los datos de las cotizaciones
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
      appBar: AppBar(
        title: const Text('Cotizaciones'),
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
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: _quotes.map((quote) {
                  return DataRow(cells: [
                    DataCell(Text(quote.productLicense)),
                    DataCell(Text(quote.quantity.toString())),
                    DataCell(Text('\$${quote.price}')),
                    DataCell(Text(quote.clientName)),
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
                            setState(() {
                              _quotes.remove(quote);
                            });
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
                      decoration: const InputDecoration(
                          labelText: 'Codigo de producto (Licencia.)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el Codigo de producto (Licencia.)';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _productLicense = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la cantidad';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _price = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Nombre del Cliente'),
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
