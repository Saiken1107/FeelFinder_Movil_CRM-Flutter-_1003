// suscripcion_form.dart
import 'package:feelfinder_mobile/controllers/suscripcion_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuscripcionForm extends StatefulWidget {
  final int? suscripcionId;
  final List<Map<String, dynamic>> clientes;
  final List<Map<String, dynamic>> planes;
  final VoidCallback onSubmit;

  SuscripcionForm({
    this.suscripcionId,
    required this.clientes,
    required this.planes,
    required this.onSubmit,
  });

  @override
  _SuscripcionFormState createState() => _SuscripcionFormState();
}

class _SuscripcionFormState extends State<SuscripcionForm> {
  final SuscripcionController _suscripcionController = SuscripcionController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String? _clienteId;
  String? _planId;
  String? _estado;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStartDate ? _fechaInicio : _fechaFin)) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }
  
  void _submitForm() async {
    if (_clienteId == null || _planId == null || _estado == null || _fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return;
    }

    // Datos a enviar
    final data = {
      "fechaDeInicio": _fechaInicio!.toIso8601String(),
      "fechaDeFin": _fechaFin!.toIso8601String(),
      "estado": _estado,
      "clienteId": int.parse(_clienteId!),
      "planId": int.parse(_planId!),
    };

    try {
      print("Enviando datos de suscripción: $data");
      if (widget.suscripcionId == null) {
        await _suscripcionController.registrarSuscripcion(data);
        print("Suscripción registrada con éxito.");
      } else {
        await _suscripcionController.actualizarSuscripcion(widget.suscripcionId!, data);
        print("Suscripción actualizada con éxito.");
      }
      widget.onSubmit();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al guardar la suscripción: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar la suscripción")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Cliente"),
            items: widget.clientes.map((cliente) {
              return DropdownMenuItem(
                value: cliente["id"].toString(),
                child: Text(cliente["nombre"]),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _clienteId = value);
            },
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Plan de Suscripción"),
            items: widget.planes.map((plan) {
              return DropdownMenuItem(
                value: plan["id"].toString(),
                child: Text(plan["nombre"]),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _planId = value);
            },
          ),
          ListTile(
            title: Text("Fecha de Inicio: ${_fechaInicio != null ? DateFormat('yyyy-MM-dd').format(_fechaInicio!) : 'Selecciona la fecha'}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, true),
          ),
          ListTile(
            title: Text("Fecha de Fin: ${_fechaFin != null ? DateFormat('yyyy-MM-dd').format(_fechaFin!) : 'Selecciona la fecha'}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, false),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Estado"),
            items: ["Activa", "Inactiva", "Pendiente"].map((estado) {
              return DropdownMenuItem(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _estado = value);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(widget.suscripcionId == null ? "Registrar" : "Actualizar"),
          ),
        ],
      ),
    );
  }
}
