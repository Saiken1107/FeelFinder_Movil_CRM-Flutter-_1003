// pages/opportunities_page.dart
import 'package:feelfinder_mobile/services/oportunidad_venta_servicio.dart';
import 'package:flutter/material.dart';
import '../../../models/oportunidad_venta.dart';

class OportunidadesPage extends StatefulWidget {
  const OportunidadesPage({super.key});

  @override
  _OpportunitiesPageState createState() => _OpportunitiesPageState();





}

class _OpportunitiesPageState extends State<OportunidadesPage> {
  final List<OportunidadVenta> _opportunities = [];
  final OportunidadVentaServicio servicio = OportunidadVentaServicio();

  @override
  void initState() {
    super.initState();
    _loadOpportunities();
  }

  // Método para cargar oportunidades
  void _loadOpportunities() async {
    try {
      final oportunidades = await servicio.obtenerOportunidadesVenta();
      setState(() {
        _opportunities.addAll(oportunidades);
      });
    } catch (e) {
      print('Error al cargar oportunidades: $e');
    }
  }

  // Método para agregar nuevas oportunidades
  void _addNewOpportunity() {
    _showOpportunityDialog();
  }

  // Método para editar oportunidades existentes
  void _editOpportunity(int index) {
    final oportunidad = _opportunities[index];
    _showOpportunityDialog(oportunidad: oportunidad, index: index);
  }

  // Método para eliminar oportunidades
  void _deleteOpportunity(int index) async {
    try {
      final oportunidad = _opportunities[index];
      await servicio.eliminarOportunidadVenta(oportunidad.id);
      setState(() {
        _opportunities.removeAt(index);
      });
    } catch (e) {
      print('Error al eliminar oportunidad: $e');
    }
  }

  // Diálogo para agregar o editar oportunidades
  void _showOpportunityDialog({OportunidadVenta? oportunidad, int? index}) {
    final _nombreController =
        TextEditingController(text: oportunidad?.nombreCliente ?? '');
    final _descripcionController =
        TextEditingController(text: oportunidad?.descripcion ?? '');
    final _valorEstimadoController = TextEditingController(
        text: oportunidad != null ? oportunidad.valorEstimado.toString() : '');
    DateTime? _fechaCierre = oportunidad?.fechaCierre;
    String _estado = oportunidad?.estado ?? 'Pendiente';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(oportunidad == null
              ? 'Agregar Oportunidad'
              : 'Editar Oportunidad'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration:
                      const InputDecoration(hintText: 'Nombre del cliente'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(hintText: 'Descripción'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _valorEstimadoController,
                  decoration: const InputDecoration(hintText: 'Valor estimado'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _fechaCierre = pickedDate;
                    }
                  },
                  child: Text(
                    _fechaCierre == null
                        ? 'Seleccionar Fecha de Cierre'
                        : 'Fecha: ${_fechaCierre!.toLocal()}'.split(' ')[0],
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _estado,
                  items: const [
                    DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(value: 'Completada', child: Text('Completada')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _estado = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_nombreController.text.isNotEmpty &&
                    _descripcionController.text.isNotEmpty &&
                    _valorEstimadoController.text.isNotEmpty &&
                    _fechaCierre != null) {
                  try {
                    final nuevaOportunidad = OportunidadVenta(
                      id: oportunidad?.id ?? 0, // Si es edición, usa el ID existente
                      nombreCliente: _nombreController.text,
                      descripcion: _descripcionController.text,
                      valorEstimado:
                          int.parse(_valorEstimadoController.text),
                      fechaCierre: _fechaCierre!,
                      estado: _estado,
                    );

                    if (oportunidad == null) {
                      // Agregar nueva oportunidad
                      await servicio.crearOportunidadVenta(nuevaOportunidad);
                      setState(() {
                        _opportunities.add(nuevaOportunidad);
                      });
                    } else {
                      // Editar oportunidad existente
                      await servicio.actualizarOportunidadVenta(
                          oportunidad.id, nuevaOportunidad);
                      setState(() {
                        _opportunities[index!] = nuevaOportunidad;
                      });
                    }

                    Navigator.pop(context);
                  } catch (e) {
                    print('Error al guardar oportunidad: $e');
                  }
                } else {
                  print('Por favor completa todos los campos.');
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

void _showDeleteConfirmation(int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta oportunidad?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el modal sin hacer nada.
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteOpportunity(index); // Llamar al método de eliminación.
              Navigator.pop(context); // Cerrar el modal.
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oportunidades de Venta')),
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          final oportunidad = _opportunities[index];
          return ListTile(
            title: Text(oportunidad.nombreCliente),
            subtitle: Text(oportunidad.descripcion),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editOpportunity(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmation(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewOpportunity,
        child: const Icon(Icons.add),
      ),
    );
  }
}

