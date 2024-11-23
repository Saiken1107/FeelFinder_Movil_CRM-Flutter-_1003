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
      final cliente = clientes.firstWhere(
          (c) => c['id'] == suscripcion['clienteId'],
          orElse: () => {});
      final plan = planes.firstWhere((p) => p['id'] == suscripcion['planId'],
          orElse: () => {});

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
    final suscripcion =
        _suscripciones.firstWhere((s) => s['id'] == suscripcionId);
    final pagosFiltrados =
        pagos.where((p) => p['suscripcionId'] == suscripcionId).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, size: 28, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Detalles de la Suscripción',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(thickness: 1, height: 20),
            SizedBox(height: 8),
            Text("Cliente: ${suscripcion["clienteNombre"]}"),
            Text("Plan: ${suscripcion["planNombre"]}"),
            Text("Fecha Inicio: ${suscripcion["fechaDeInicio"]}"),
            Text("Fecha Fin: ${suscripcion["fechaDeFin"]}"),
            Text("Estado: ${suscripcion["estado"]}"),
            SizedBox(height: 16),
            Text(
              'Pagos Asociados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            pagosFiltrados.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: pagosFiltrados.length,
                    itemBuilder: (context, index) {
                      final pago = pagosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading:
                              Icon(Icons.attach_money, color: Colors.green),
                          title: Text("Cantidad: \$${pago["cantidad"]}"),
                          subtitle: Text(
                            "Fecha: ${DateFormat.yMMMd().format(DateTime.parse(pago["fechaDePago"]))}",
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child:
                        Text("No hay pagos registrados para esta suscripción"),
                  ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _mostrarFormularioPago(suscripcionId),
              child: Text("Registrar Pago"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
          _mostrarDetallesSuscripcion(
              suscripcionId); // Refrescar detalles de suscripción
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _suscripciones.length,
                itemBuilder: (context, index) {
                  final suscripcion = _suscripciones[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        suscripcion["clienteNombre"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Plan: ${suscripcion["planNombre"]}"),
                          Text(
                            "Estado: ${suscripcion["estado"]}",
                            style: TextStyle(
                              color: suscripcion["estado"] == "Activo"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _mostrarFormulario(id: suscripcion["id"]),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmarEliminacion(suscripcion["id"]),
                          ),
                        ],
                      ),
                      onTap: () =>
                          _mostrarDetallesSuscripcion(suscripcion["id"]),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _mostrarFormulario,
          label: Text("Agregar"),
          icon: Icon(Icons.add)),
    );
  }
}

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
    if (_formKey.currentState?.validate() ?? false) {
      if (_fechaDePago == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor, selecciona una fecha de pago.")),
        );
        return;
      }

      final data = {
        "cantidad": double.parse(_cantidadController.text),
        "fechaDePago": _fechaDePago!.toIso8601String(),
        "suscripcionId": widget.suscripcionId,
      };

      try {
        await PagoController().registrarPago(data);
        widget.onSubmit();
        Navigator.pop(context); // Cerrar la ventana después del envío
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Encabezado de la ventana
              Row(
                children: [
                  Icon(Icons.payment, size: 28, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    "Registrar Pago",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(thickness: 1, height: 20),
              SizedBox(height: 10),

              // Campo para la cantidad
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(
                  labelText: "Cantidad",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingresa una cantidad válida.";
                  }
                  final cantidad = double.tryParse(value);
                  if (cantidad == null || cantidad <= 0) {
                    return "La cantidad debe ser mayor a 0.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Selector de fecha
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.grey[200],
                title: Text(
                  _fechaDePago != null
                      ? "Fecha de Pago: ${DateFormat.yMMMd().format(_fechaDePago!)}"
                      : "Selecciona la Fecha de Pago",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.blue),
                onTap: _selectFechaDePago,
              ),
              SizedBox(height: 16),

              // Botón para guardar
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.save),
                label: Text("Guardar Pago"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
