import 'package:flutter/material.dart';
import '../services/opportunity_service.dart';

class OpportunityController extends ChangeNotifier {
  final OpportunityService _opportunityService = OpportunityService();
  List<Map<String, dynamic>> _opportunities = [];

  List<Map<String, dynamic>> get opportunities => _opportunities;

  Future<void> fetchOpportunities() async {
    try {
      _opportunities = await _opportunityService.obtenerOportunidades();
      notifyListeners();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> addOpportunity(Map<String, dynamic> opportunity) async {
    try {
      await _opportunityService.registrarOportunidad(
        opportunity['clientName'],
        opportunity['licenseQuantity'],
        opportunity['status'],
      );
      fetchOpportunities();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> updateOpportunity(Map<String, dynamic> opportunity) async {
    try {
      await _opportunityService.actualizarOportunidad(
        opportunity['id'],
        opportunity['clientName'],
        opportunity['licenseQuantity'],
        opportunity['status'],
      );
      fetchOpportunities();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> deleteOpportunity(String id) async {
    try {
      await _opportunityService.eliminarOportunidad(id);
      fetchOpportunities();
    } catch (e) {
      // Manejar error
    }
  }
}
