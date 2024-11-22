import 'package:flutter/material.dart';
import 'package:feelfinder_mobile/controllers/quejas_controller.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/detalle_queja_page.dart';
import 'package:feelfinder_mobile/views/screens/drawer_pages/nueva_queja_page.dart';

class QuejasPage extends StatefulWidget {
  @override
  _QuejasPageState createState() => _QuejasPageState();
}

class _QuejasPageState extends State<QuejasPage> {
  final QuejaController _quejaController = QuejaController();
  late Future<List<Map<String, dynamic>>> _futureQuejas;

  final Map<int, Map<String, dynamic>> estatusMap = {
    1: {
      "label": "Registrado",
      "color": Colors.blue,
      "icon": Icons.fiber_manual_record
    },
    2: {
      "label": "Pendiente",
      "color": Colors.orange,
      "icon": Icons.hourglass_empty
    },
    3: {
      "label": "Implementado",
      "color": Colors.green,
      "icon": Icons.check_circle
    },
    4: {"label": "Terminado", "color": Colors.purple, "icon": Icons.done_all},
    5: {"label": "Cancelado", "color": Colors.red, "icon": Icons.cancel},
  };

  final List<Map<String, dynamic>> tiposQueja = [
    {"id": 1, "tipo": "Mejora"},
    {"id": 2, "tipo": "Queja"},
    {"id": 3, "tipo": "Error"},
    {"id": 4, "tipo": "Sugerencias"},
  ];

  int? _selectedEstatus; // Estatus seleccionado para el filtro
  int? _selectedTipo; // Tipo seleccionado para el filtro

  @override
  void initState() {
    super.initState();
    _futureQuejas = _quejaController.obtenerQuejas();
  }

  void _recargarQuejas() {
    setState(() {
      _futureQuejas = _quejaController.obtenerQuejas();
    });
  }

  String getTipoById(int tipoId) {
    return tiposQueja.firstWhere((tipo) => tipo['id'] == tipoId,
        orElse: () => {"tipo": "Desconocido"})['tipo'];
  }

  String getNombreUsuario(
      int idUsuario, List<Map<String, dynamic>> profesionales) {
    try {
      final persona = profesionales.firstWhere(
        (profesional) => profesional['persona']['id'] == idUsuario,
        orElse: () => {
          "persona": {"nombre": "Desconocido", "apellido": ""}
        },
      )['persona'];
      return "${persona['nombre']} ${persona['apellido']}";
    } catch (e) {
      return "Desconocido";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Quejas/Sugerencias"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _recargarQuejas,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros de Estatus y Tipo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedEstatus,
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text("Ver todas"),
                      ),
                      ...estatusMap.entries.map(
                        (entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value['label']),
                        ),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: "Filtrar por Estatus",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedEstatus = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedTipo,
                    items: [
                      DropdownMenuItem<int>(
                        value: null,
                        child: Text("Ver todas"),
                      ),
                      ...tiposQueja.map(
                        (tipo) => DropdownMenuItem<int>(
                          value: tipo['id'],
                          child: Text(tipo['tipo']),
                        ),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: "Filtrar por Tipo",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedTipo = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureQuejas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay quejas registradas.'));
                } else {
                  final quejas = snapshot.data!;
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: _quejaController.obtenerProfesionales(),
                    builder: (context, profesionalesSnapshot) {
                      if (profesionalesSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (profesionalesSnapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error al cargar profesionales: ${profesionalesSnapshot.error}'));
                      }

                      final profesionales = profesionalesSnapshot.data ?? [];

                      // Aplicar filtros
                      final filteredQuejas = quejas.where((queja) {
                        if (_selectedEstatus != null &&
                            queja['estatus'] != _selectedEstatus) {
                          return false;
                        }
                        if (_selectedTipo != null &&
                            queja['tipo'] != _selectedTipo) {
                          return false;
                        }
                        return true;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredQuejas.length,
                        itemBuilder: (context, index) {
                          final queja = filteredQuejas[index];
                          final estatus = queja['estatus'] ?? 1;
                          final estatusInfo = estatusMap[estatus] ??
                              {
                                "label": "Desconocido",
                                "color": Colors.grey,
                                "icon": Icons.help,
                              };
                          final tipo = getTipoById(queja['tipo']);
                          final solicitanteNombre = getNombreUsuario(
                              queja['idUsuarioSolicita'], profesionales);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            elevation: 5,
                            child: ListTile(
                              leading: Icon(
                                estatusInfo['icon'],
                                color: estatusInfo['color'],
                                size: 40,
                              ),
                              title: Text(
                                queja['descripcion'] ?? 'Sin descripción',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    "Usuario Solicitante: $solicitanteNombre",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Tipo: $tipo",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Estatus: ${estatusInfo['label']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: estatusInfo['color'],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetalleQuejaPage(queja: queja),
                                  ),
                                );
                                _recargarQuejas();
                              },
                            ),
                          );
                        },
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
            MaterialPageRoute(
              builder: (context) => NuevaQuejaPage(),
            ),
          );
          _recargarQuejas();
        },
        child: Icon(Icons.add),
        tooltip: "Añadir nueva queja",
      ),
    );
  }
}
