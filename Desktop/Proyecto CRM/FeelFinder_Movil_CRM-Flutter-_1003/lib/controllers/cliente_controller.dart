// cliente_controller.dart
import '../services/cliente_service.dart';

class ClienteController {
  final ClienteService _clienteService = ClienteService();

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      return await _clienteService.obtenerClientes();
    } catch (e) {
      print("Error en obtenerClientes: $e");
      return []; // Retorna lista vacía en caso de error
    }
  }

  Future<void> registrarCliente(
      String correo, String nombre, String apellido) async {
    try {
      await _clienteService.registrarCliente(correo, nombre, apellido);
    } catch (e) {
      print("Error en registrarCliente: $e");
      throw Exception('No se pudo registrar el cliente');
    }
  }

  Future<void> actualizarCliente(
      int id, String correo, String nombre, String apellido) async {
    try {
      await _clienteService.actualizarCliente(id, correo, nombre, apellido);
    } catch (e) {
      print("Error en actualizarCliente: $e");
      throw Exception('No se pudo actualizar el cliente');
    }
  }

  Future<void> eliminarCliente(int id) async {
    try {
      await _clienteService.eliminarCliente(id);
    } catch (e) {
      print("Error en eliminarCliente: $e");
      throw Exception('No se pudo eliminar el cliente');
    }
  }
}
