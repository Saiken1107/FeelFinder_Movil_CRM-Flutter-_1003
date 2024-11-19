// pages/price_list_page.dart
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listas de Precios')),
      body: ListView.builder(
        itemCount: _priceLists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_priceLists[index].name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar acción para agregar nueva lista de precios
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
