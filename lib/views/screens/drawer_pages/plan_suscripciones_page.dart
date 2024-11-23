// planes_suscripcion_page.dart
import 'package:feelfinder_mobile/controllers/plan_suscripcion_controller.dart';
import 'package:flutter/material.dart';

class PlanesSuscripcionesPage extends StatefulWidget {
  const PlanesSuscripcionesPage({Key? key}) : super(key: key);

  @override
  State<PlanesSuscripcionesPage> createState() => _PlanesSuscripcionPageState();
}

class _PlanesSuscripcionPageState extends State<PlanesSuscripcionesPage> {
  List<Map<String, dynamic>> _planes = [];
  final planController = PlanSuscripcionController();

  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlanes();
  }

  void _loadPlanes() async {
    try {
      final planes = await planController.obtenerPlanes();
      setState(() {
        _planes = planes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError("Error al cargar planes: $e");
    }
  }

  Future<void> _addOrUpdatePlan({int? id}) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (id == null) {
          await planController.registrarPlan(
            _nombreController.text,
            double.parse(_precioController.text),
            _descripcionController.text,
            int.parse(_duracionController.text),
          );
          _showSuccess("Plan agregado exitosamente.");
        } else {
          await planController.actualizarPlan(
            id,
            _nombreController.text,
            double.parse(_precioController.text),
            _descripcionController.text,
            int.parse(_duracionController.text),
          );
          _showSuccess("Plan actualizado exitosamente.");
        }
        _loadPlanes();
        Navigator.of(context).pop();
      } catch (e) {
        _showError("Error al registrar el plan: $e");
      }
    }
  }

  void _deletePlan(int id) async {
    try {
      await planController.eliminarPlan(id);
      _showSuccess("Plan eliminado.");
      _loadPlanes();
    } catch (e) {
      _showError("No se pudo eliminar el plan: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showForm({int? id}) {
    if (id != null) {
      final plan = _planes.firstWhere((plan) => plan['id'] == id);
      _nombreController.text = plan['nombre'];
      _precioController.text = plan['precio'].toString();
      _descripcionController.text = plan['descripcion'];
      _duracionController.text = plan['duracionMeses'].toString();
    } else {
      _nombreController.clear();
      _precioController.clear();
      _descripcionController.clear();
      _duracionController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
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
                Text(
                  id == null ? "Agregar Plan" : "Actualizar Plan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre del Plan",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El nombre no puede estar vacío.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _precioController,
                  decoration: InputDecoration(
                    labelText: "Precio",
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El precio no puede estar vacío.";
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return "El precio debe ser un número mayor a 0.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La descripción no puede estar vacía.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _duracionController,
                  decoration: InputDecoration(
                    labelText: "Duración (meses)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "La duración no puede estar vacía.";
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return "La duración debe ser un número mayor a 0.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addOrUpdatePlan(id: id),
                  child: Text(id == null ? "Agregar Plan" : "Actualizar Plan"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Planes de Suscripción")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _planes.length,
                itemBuilder: (context, index) {
                  final plan = _planes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        plan['nombre'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Precio: \$${plan['precio']}"),
                          Text("Duración: ${plan['duracionMeses']} meses"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePlan(plan['id']),
                      ),
                      onTap: () => _showForm(id: plan['id']),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        label: Text("Agregar"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
