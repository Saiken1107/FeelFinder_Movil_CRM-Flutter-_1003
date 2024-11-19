import 'package:feelfinder_mobile/controllers/plan_suscripcion_controller.dart';
import 'package:flutter/material.dart';

class PlanSuscripcionesPage extends StatefulWidget {
  const PlanSuscripcionesPage({Key? key}) : super(key: key);

  @override
  State<PlanSuscripcionesPage> createState() => _PlanSuscripcionesPageState();
}

class _PlanSuscripcionesPageState extends State<PlanSuscripcionesPage> {
  List<Map<String, dynamic>> _planes = [];
  final planController = PlanSuscripcionController();

  bool _isLoading = true;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  void _loadPlanes() async {
    final planes = await planController.obtenerPlanes();
    setState(() {
      _planes = planes;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPlanes();
  }

  Future<void> _addPlan() async {
    await planController.insertarPlan(_nombreController.text, double.parse(_precioController.text), 12); // Puedes ajustar la duración según sea necesario
    _loadPlanes();
    Navigator.of(context).pop();
  }

  Future<void> _updatePlan(int id) async {
    await planController.modificarPlan(id, _nombreController.text, double.parse(_precioController.text));
    _loadPlanes();
    Navigator.of(context).pop();
  }

  void _deletePlan(int id) async {
    await planController.eliminarPlan(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Plan de suscripción eliminado")));
    _loadPlanes();
  }

  void _showForm(int? id) {
    if (id != null) {
      final plan = _planes.firstWhere((plan) => plan['id'] == id);
      _nombreController.text = plan['nombre'];
      _precioController.text = plan['precio'].toString();
    } else {
      _nombreController.clear();
      _precioController.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
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
                  subtitle: Text("Precio: \$${plan['precio']} - Duración: ${plan['duracionMeses']} meses"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showForm(plan['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePlan(plan['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
