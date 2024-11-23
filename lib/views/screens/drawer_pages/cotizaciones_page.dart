import 'package:feelfinder_mobile/controllers/cliente_controller.dart';
import 'package:feelfinder_mobile/controllers/cotizacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CotizacionesPage extends StatefulWidget {
  const CotizacionesPage({Key? key}) : super(key: key);

  @override
  State<CotizacionesPage> createState() => _CotizacionesPageState();
}

class _CotizacionesPageState extends State<CotizacionesPage> {
  final CotizacionController _cotizacionController = CotizacionController();
  final ClienteController _clienteController = ClienteController();

  List<Map<String, dynamic>> _cotizaciones = [];
  List<Map<String, dynamic>> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final clientes = await _clienteController.obtenerClientes();
    final cotizaciones = await _cotizacionController.obtenerCotizaciones();

    final cotizacionesConNombres = cotizaciones.map((cotizacion) {
      final cliente = clientes.firstWhere(
          (c) => c['id'] == cotizacion['clienteId'],
          orElse: () => {});
      return {
        ...cotizacion,
        'clienteNombre': cliente.isNotEmpty ? cliente['nombre'] : 'Desconocido',
      };
    }).toList();

    setState(() {
      _clientes = clientes;
      _cotizaciones = cotizacionesConNombres;
      _isLoading = false;
    });
  }

  void _mostrarFormulario({int? id}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return CotizacionForm(
          cotizacionId: id,
          clientes: _clientes,
          onSubmit: _cargarDatos,
        );
      },
    );
  }

  void _eliminarCotizacion(int cotizacionId) async {
    try {
      await _cotizacionController.eliminarCotizacion(cotizacionId);
      _cargarDatos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cotización eliminada exitosamente.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar la cotización.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotizaciones')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cotizaciones.length,
              itemBuilder: (context, index) {
                final cotizacion = _cotizaciones[index];
                return ListTile(
                  title: Text(cotizacion['descripcion']),
                  subtitle: Text("Cliente: ${cotizacion['clienteNombre']}"),
                  onTap: () => _mostrarFormulario(id: cotizacion['id']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarCotizacion(cotizacion['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CotizacionForm extends StatefulWidget {
  final int? cotizacionId;
  final List<Map<String, dynamic>> clientes;
  final VoidCallback onSubmit;

  const CotizacionForm({
    Key? key,
    this.cotizacionId,
    required this.clientes,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CotizacionFormState createState() => _CotizacionFormState();
}

class _CotizacionFormState extends State<CotizacionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  DateTime? _fecha;
  int? _clienteSeleccionado;

  void _seleccionarFecha() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _fecha = pickedDate;
      });
    }
  }

  void _guardarFormulario() async {
    if (_formKey.currentState!.validate() &&
        _clienteSeleccionado != null &&
        _fecha != null) {
      final cotizacionData = {
        'clienteId': _clienteSeleccionado,
        'descripcion': _descripcionController.text,
        'precio': double.parse(_precioController.text),
        'fecha': _fecha!.toIso8601String(),
      };

      try {
        if (widget.cotizacionId == null) {
          await CotizacionController().registrarCotizacion(cotizacionData);
        } else {
          await CotizacionController()
              .actualizarCotizacion(widget.cotizacionId!, cotizacionData);
        }
        widget.onSubmit();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la cotización: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _clienteSeleccionado,
              items: widget.clientes.map((cliente) {
                return DropdownMenuItem<int>(
                  value: cliente['id'],
                  child: Text(cliente['nombre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _clienteSeleccionado = value;
                });
              },
              decoration: const InputDecoration(labelText: "Cliente"),
              validator: (value) =>
                  value == null ? "Selecciona un cliente" : null,
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: "Descripción"),
              validator: (value) => value == null || value.isEmpty
                  ? "Ingresa una descripción"
                  : null,
            ),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? "Ingresa un precio" : null,
            ),
            ListTile(
              title: Text(_fecha != null
                  ? "Fecha: ${DateFormat.yMd().format(_fecha!)}"
                  : "Selecciona una fecha"),
              trailing: const Icon(Icons.calendar_today),
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarFormulario,
              child:
                  Text(widget.cotizacionId == null ? "Agregar" : "Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
