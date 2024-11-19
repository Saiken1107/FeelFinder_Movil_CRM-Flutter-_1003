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
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _loadPlanes();
  }

  Future<void> _addPlan() async {
    try {
      await planController.registrarPlan(
        _nombreController.text,
        double.parse(_precioController.text),
        _descripcionController.text,
        int.parse(_duracionController.text),
      );
      _loadPlanes();
      Navigator.of(context).pop();
    } catch (e) {
      _showError("No se pudo registrar el plan: $e");
    }
  }

  Future<void> _updatePlan(int id) async {
    try {
      await planController.actualizarPlan(
        id,
        _nombreController.text,
        double.tryParse(_precioController.text),
        _descripcionController.text,
        int.tryParse(_duracionController.text),
      );
      _loadPlanes();
      Navigator.of(context).pop();
    } catch (e) {
      _showError("No se pudo actualizar el plan: $e");
    }
  }

  void _deletePlan(int id) async {
    try {
      await planController.eliminarPlan(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Plan eliminado")),
      );
      _loadPlanes();
    } catch (e) {
      _showError("No se pudo eliminar el plan: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
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
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Plan'),
              ),
              TextField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _duracionController,
                decoration: InputDecoration(labelText: 'Duración (meses)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(id == null ? 'Agregar Plan' : 'Actualizar Plan'),
                onPressed: () async {
                  if (id == null) {
                    await _addPlan();
                  } else {
                    await _updatePlan(id);
                  }
                },
              )
            ],
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
          : ListView.builder(
              itemCount: _planes.length,
              itemBuilder: (context, index) {
                final plan = _planes[index];
                return ListTile(
                  title: Text(plan['nombre']),
                  subtitle: Text("Precio: ${plan['precio']}"),
                  onTap: () => _showForm(id: plan['id']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deletePlan(plan['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
