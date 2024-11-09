import 'package:flutter/material.dart';
import '../../../models/lista_precios.dart';

class PreciosPage extends StatefulWidget {
  const PreciosPage({super.key});

  @override
  _PriceListPageState createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PreciosPage> {
  final List<PriceList> _priceLists = [];

  void _addPriceList(PriceList priceList) {
    setState(() {
      _priceLists.add(priceList);
    });
  }

  void _editPriceList(int index, PriceList updatedPriceList) {
    setState(() {
      _priceLists[index] = updatedPriceList;
    });
  }

  void _deletePriceList(int index) {
    setState(() {
      _priceLists.removeAt(index);
    });
  }

  void _showAddPriceListDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Lista de Precios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
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
                final double price =
                    double.tryParse(priceController.text) ?? 0.0;
                final PriceList priceList = PriceList(
                    id: UniqueKey().toString(),
                    name: name,
                    price: price,
                    prices: []);
                _addPriceList(priceList);
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
        itemCount: _priceLists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_priceLists[index].name),
            subtitle: Text('\$${_priceLists[index].price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Implementar la edición de la lista de precios
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deletePriceList(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPriceListDialog,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
