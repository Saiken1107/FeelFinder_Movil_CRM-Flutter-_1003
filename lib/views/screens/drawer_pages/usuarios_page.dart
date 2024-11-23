import 'package:flutter/material.dart';
import '../../../services/quejas_service.dart'; // Importa tu archivo donde está definido QuejaService

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final QuejaService quejaService = QuejaService();
  String searchQuery = ""; // Almacena el texto de búsqueda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Profesionales'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar profesional',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: quejaService.obtenerProfesional(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No hay profesionales disponibles'));
                } else {
                  // Filtrar los profesionales según el texto de búsqueda
                  List<Map<String, dynamic>> profesionales =
                      snapshot.data!.where((profesional) {
                    final persona = profesional['persona'];
                    final nombreCompleto =
                        '${persona?['nombre'] ?? ''} ${persona?['apellido'] ?? ''}'
                            .toLowerCase();
                    return nombreCompleto.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (profesionales.isEmpty) {
                    return Center(child: Text('No se encontraron resultados'));
                  }

                  return ListView.builder(
                    itemCount: profesionales.length,
                    itemBuilder: (context, index) {
                      final profesional = profesionales[index];
                      final persona = profesional['persona'];
                      final profesionalInfo = profesional['profesional'];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child:
                                Icon(Icons.person, color: Colors.blue.shade800),
                          ),
                          title: Text(
                            persona != null
                                ? '${persona['nombre']} ${persona['apellido']}'
                                : 'Sin nombre',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            profesionalInfo != null
                                ? profesionalInfo['titulo'] ?? 'Sin título'
                                : 'Psicologo',
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () {
                            // Acción al tocar el profesional
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.info, color: Colors.blue),
                                    SizedBox(width: 10),
                                    Text('Detalle'),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                      icon: Icons.person,
                                      label: 'Nombre:',
                                      value: persona != null
                                          ? persona['nombre'] ?? 'N/A'
                                          : 'N/A',
                                    ),
                                    _buildDetailRow(
                                      icon: Icons.person_outline,
                                      label: 'Apellido:',
                                      value: persona != null
                                          ? persona['apellido'] ?? 'N/A'
                                          : 'N/A',
                                    ),
                                    _buildDetailRow(
                                      icon: Icons.school,
                                      label: 'Título:',
                                      value: profesionalInfo != null
                                          ? profesionalInfo['titulo'] ?? 'N/A'
                                          : 'Psicologo',
                                    ),
                                    _buildDetailRow(
                                      icon: Icons.email,
                                      label: 'Correo:',
                                      value: profesional['email'],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cerrar'),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineación superior
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Evita desbordamientos
              maxLines: 1, // Limita a una sola línea
            ),
          ),
        ],
      ),
    );
  }
}
