import 'package:feelfinder_mobile/views/screens/drawer_pages/registro_empresas_page.dart';
import 'package:flutter/material.dart';
import '../../../services/empresa_service.dart'; // Servicio para manejar los datos de las empresas

class EmpresasPage extends StatefulWidget {
  @override
  _EmpresasPageState createState() => _EmpresasPageState();
}

String obtenerEstatus(int? estatus) {
  if (estatus == null) return 'No disponible';
  return estatus == 1 ? 'Activo' : 'Inactivo';
}

class _EmpresasPageState extends State<EmpresasPage> {
  final EmpresaController _empresaController = EmpresaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Empresas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _empresaController.obtenerEmpresas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar empresas"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No se encontraron empresas"));
          } else {
            final empresas = snapshot.data!;
            return ListView.builder(
              itemCount: empresas.length,
              itemBuilder: (context, index) {
                final empresa = empresas[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmpresaDetailScreen(empresa: empresa),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistroEmpresasPage()),
          );
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

class EmpresaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> empresa;

  EmpresaDetailScreen({required this.empresa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(empresa['nombreEmpresa'] ?? 'Detalle de la empresa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título Principal
            Center(
              child: Text(
                empresa['nombreEmpresa'] ?? 'Sin nombre',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Detalles en tarjetas
            detalleEmpresa(
              Icons.location_on,
              'Dirección',
              empresa['direccion'],
            ),
            detalleEmpresa(
              Icons.phone,
              'Teléfono',
              empresa['telefono'],
            ),
            detalleEmpresa(
              Icons.email,
              'Correo',
              empresa['correo'],
            ),
            detalleEmpresa(
              Icons.check_circle,
              'Estatus',
              obtenerEstatus(empresa['estatus']),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              label: Text("Cerrar"),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Mejorado para Detalles
  Widget detalleEmpresa(IconData icon, String titulo, String? valor) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.purple),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    valor ?? 'No disponible',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
