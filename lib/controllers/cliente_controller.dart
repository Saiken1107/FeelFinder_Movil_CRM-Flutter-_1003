// cliente_controller.dart
import '../services/cliente_service.dart';

class ClienteController {
  final ClienteService _clienteService = ClienteService();

  Future<List<Map<String, dynamic>>> obtenerClientes() {
    return _clienteService.obtenerClientes();
  }

  Future<void> insertarCliente(String nombre, String correo) {
    return _clienteService.insertarCliente(nombre, correo);
  }

  Future<void> modificarCliente(int id, String nombre) {
    return _clienteService.modificarCliente(id, nombre);
  }

  Future<void> eliminarCliente(int id) {
    return _clienteService.eliminarCliente(id);
  }
}
