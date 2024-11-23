import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/models/lista_precios.dart';
import 'package:feelfinder_mobile/services/lista_precios_service.dart';

class ListaPreciosPage extends StatefulWidget {
  @override
  _ListaPreciosPaginaState createState() => _ListaPreciosPaginaState();
}

class _ListaPreciosPaginaState extends State<ListaPreciosPage> {
  final ListaPreciosServicio _listaPreciosServicio = ListaPreciosServicio();
  late Future<List<ListaPrecios>> _listasPrecios;

  @override
  void initState() {
    super.initState();
    _listasPrecios = _listaPreciosServicio.obtenerListasPrecios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas de Precios'),
      ),
      body: FutureBuilder<List<ListaPrecios>>(
        future: _listasPrecios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return Center(child: Text('No hay listas de precios disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final listaPrecios = snapshot.data![index];
                return ListTile(
                  title: Text(listaPrecios.tipoPlan),
                  subtitle: Text(
                      'Empresa: ${listaPrecios.empresa}, Precio Final: ${listaPrecios.precioFinal}'),
                  onTap: () {
                    // Navegar a la página de detalles
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página de creación de lista de precios
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
