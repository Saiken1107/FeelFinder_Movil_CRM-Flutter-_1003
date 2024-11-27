import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/registro_empresas_page.dart';
import '../../../services/empresa_service.dart'; // Servicio para manejar los datos de las empresas
import 'actualizar_empresa_page.dart'; // Página para actualizar empresa

String obtenerEstatus(int? estatus) {
  if (estatus == null) return 'No disponible';
  return estatus == 1 ? 'Activo' : 'Inactivo';
}

class EmpresasPage extends StatefulWidget {
  @override
  _EmpresasPageState createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  final EmpresaController _empresaController = EmpresaController();
  late Future<List<Map<String, dynamic>>> _futureEmpresas;

  // Filtros
  String _searchQuery = '';
  int? _selectedEstatus = null;

  @override
  void initState() {
    super.initState();
    _futureEmpresas = _empresaController.obtenerEmpresas();
  }

  void _recargarEmpresas() {
    setState(() {
      _futureEmpresas = _empresaController.obtenerEmpresas();
    });
  }

  // Filtrar empresas en tiempo real
  List<Map<String, dynamic>> _filtrarEmpresas(
      List<Map<String, dynamic>> empresas) {
    return empresas.where((empresa) {
      final nombreEmpresa = empresa['nombreEmpresa']?.toLowerCase() ?? '';
      final nombreCliente = empresa['nombreCliente']?.toLowerCase() ?? '';
      final estatus = empresa['estatus'];

      final matchesQuery = _searchQuery.isEmpty ||
          nombreEmpresa.contains(_searchQuery) ||
          nombreCliente.contains(_searchQuery);

      final matchesEstatus =
          _selectedEstatus == null || estatus == _selectedEstatus;

      return matchesQuery && matchesEstatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Empresas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _recargarEmpresas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Buscar por Nombre o Cliente",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Filtro de estatus
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<int?>(
              value: _selectedEstatus,
              items: [
                DropdownMenuItem(value: null, child: Text("Todos")),
                DropdownMenuItem(value: 1, child: Text("Activo")),
                DropdownMenuItem(value: 0, child: Text("Inactivo")),
              ],
              decoration: InputDecoration(
                labelText: "Estatus",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedEstatus = value;
                });
              },
            ),
          ),
          SizedBox(height: 8),

          // Lista de empresas
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureEmpresas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error al cargar empresas"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No se encontraron empresas"));
                } else {
                  final empresasFiltradas =
                      _filtrarEmpresas(snapshot.data!); // Aplicar filtros

                  return ListView.builder(
                    itemCount: empresasFiltradas.length,
                    itemBuilder: (context, index) {
                      final empresa = empresasFiltradas[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.business, color: Colors.purple),
                          title: Text(
                            empresa['nombreEmpresa'] ?? 'Sin nombre',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Dirección: ${empresa['direccion'] ?? 'No disponible'}'),
                              Text(
                                  'Teléfono: ${empresa['telefono'] ?? 'No disponible'}'),
                              Text(
                                  'Estatus: ${obtenerEstatus(empresa['estatus'])}'),
                            ],
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActualizarEmpresaPage(empresa: empresa),
                              ),
                            );

                            if (result == true) {
                              _recargarEmpresas();
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroEmpresasPage()),
          );
          _recargarEmpresas();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        tooltip: "Añadir nueva empresa",
      ),
    );
  }
}

class EmpresaController {
  final EmpresaService _empresaService = EmpresaService();

  Future<List<Map<String, dynamic>>> obtenerEmpresas() async {
    try {
      return await _empresaService.obtenerEmpresas();
    } catch (e) {
      print("Error en EmpresaController: $e");
      return [];
    }
  }
}
