// suscripciones_page.dart
import 'package:feelfinder_mobile/controllers/pago_%20controller.dart';
import 'package:feelfinder_mobile/controllers/suscripcion_controller.dart';
import 'package:feelfinder_mobile/views/widgets/suscripcion_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuscripcionesPage extends StatefulWidget {
  const SuscripcionesPage({Key? key}) : super(key: key);

  @override
  State<SuscripcionesPage> createState() => _SuscripcionesPageState();
}

class _SuscripcionesPageState extends State<SuscripcionesPage> {
  final SuscripcionController _suscripcionController = SuscripcionController();
  final PagoController _pagoController = PagoController();
  List<Map<String, dynamic>> _suscripciones = [];
  List<Map<String, dynamic>> _clientes = [];
  List<Map<String, dynamic>> _planes = [];
  List<Map<String, dynamic>> _pagos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final clientes = await _suscripcionController.obtenerClientes();
    final planes = await _suscripcionController.obtenerPlanes();
    final suscripciones = await _suscripcionController.obtenerSuscripciones();

    final suscripcionesConNombres = suscripciones.map((suscripcion) {
      final cliente = clientes.firstWhere((c) => c['id'] == suscripcion['clienteId'], orElse: () => {});
      final plan = planes.firstWhere((p) => p['id'] == suscripcion['planId'], orElse: () => {});

      return {
        ...suscripcion,
        'clienteNombre': cliente.isNotEmpty ? cliente['nombre'] : 'Desconocido',
        'planNombre': plan.isNotEmpty ? plan['nombre'] : 'Desconocido',
      };
    }).toList();

    setState(() {
      _clientes = clientes;
      _planes = planes;
      _suscripciones = suscripcionesConNombres;
      _isLoading = false;
    });
  }

  void _mostrarFormulario({int? id}) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SuscripcionForm(
          suscripcionId: id,
          clientes: _clientes,
          planes: _planes,
          onSubmit: _cargarDatos,
        );
      },
    );
  }

  void _mostrarDetallesSuscripcion(int suscripcionId) async {
    final pagos = await _pagoController.obtenerPagos();
    final suscripcion = _suscripciones.firstWhere((s) => s['id'] == suscripcionId);
    final pagosFiltrados = pagos.where((p) => p['suscripcionId'] == suscripcionId).toList();

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Detalles de la suscripción
            Text(
              'Detalles de la Suscripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Cliente: ${suscripcion["clienteNombre"]}'),
            Text('Plan: ${suscripcion["planNombre"]}'),
            Text('Fecha de Inicio: ${suscripcion["fechaDeInicio"]}'),
            Text('Fecha de Fin: ${suscripcion["fechaDeFin"]}'),
            Text('Estado: ${suscripcion["estado"]}'),
            SizedBox(height: 16),

            // Lista de pagos asociados
            Text(
              'Pagos Asociados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            pagosFiltrados.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: pagosFiltrados.length,
                    itemBuilder: (context, index) {
                      final pago = pagosFiltrados[index];
                      return ListTile(
                        title: Text('Cantidad: \$${pago["cantidad"]}'),
                        subtitle: Text('Fecha de Pago: ${pago["fechaDePago"]}'),
                      );
                    },
                  )
                : Center(child: Text("No hay pagos registrados para esta suscripción")),
            SizedBox(height: 16),

            // Botón para abrir formulario de registro de pago
            ElevatedButton(
              onPressed: () => _mostrarFormularioPago(suscripcionId),
              child: Text("Registrar Pago"),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarFormularioPago(int suscripcionId) {
    showModalBottomSheet(
      context: context,
      builder: (_) => PagoForm(
        suscripcionId: suscripcionId,
        onSubmit: () {
          Navigator.pop(context); // Cerrar el formulario de pago
          _mostrarDetallesSuscripcion(suscripcionId); // Refrescar detalles de suscripción
        },
      ),
    );
  }

  // Confirmación de eliminación
  void _confirmarEliminacion(int suscripcionId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar esta suscripción?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _eliminarSuscripcion(suscripcionId);
            },
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarSuscripcion(int suscripcionId) async {
    try {
      await _suscripcionController.eliminarSuscripcion(suscripcionId);
      _cargarDatos(); // Refrescar la lista de suscripciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Suscripción eliminada exitosamente.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar la suscripción.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suscripciones')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _suscripciones.length,
              itemBuilder: (context, index) {
                final suscripcion = _suscripciones[index];
                return ListTile(
                  title: Text('Cliente: ${suscripcion["clienteNombre"]}'),
                  subtitle: Text('Plan: ${suscripcion["planNombre"]}'),
                  onTap: () => _mostrarDetallesSuscripcion(suscripcion["id"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _mostrarFormulario(id: suscripcion["id"]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(suscripcion["id"]),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: Icon(Icons.add),
      ),
    );
  }
}



// Formulario de pago
class PagoForm extends StatefulWidget {
  final int suscripcionId;
  final VoidCallback onSubmit;

  PagoForm({required this.suscripcionId, required this.onSubmit});

  @override
  _PagoFormState createState() => _PagoFormState();
}

class _PagoFormState extends State<PagoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();
  DateTime? _fechaDePago;

  void _selectFechaDePago() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _fechaDePago = pickedDate;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false ) {
      final data = {
        "cantidad": double.parse(_cantidadController.text),
        "fechaDePago": _fechaDePago!.toIso8601String(),
        "suscripcionId": widget.suscripcionId,
      };

      try {
        await PagoController().registrarPago(data);
        widget.onSubmit();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al registrar el pago")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cantidadController,
              decoration: InputDecoration(labelText: "Cantidad"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa una cantidad";
                }
                return null;
              },
            ),
            ListTile(
              title: Text(_fechaDePago != null
                  ? "Fecha de Pago: ${DateFormat.yMd().format(_fechaDePago!)}"
                  : "Selecciona la Fecha de Pago"),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectFechaDePago,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Guardar Pago"),
            ),
          ],
        ),
      ),
    );
  }
}