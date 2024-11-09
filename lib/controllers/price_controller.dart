import 'package:flutter/material.dart';
import '../services/price_service.dart';

class PriceController extends ChangeNotifier {
  final PriceService _priceService = PriceService();
  List<Map<String, dynamic>> _prices = [];

  List<Map<String, dynamic>> get prices => _prices;

  Future<void> fetchPrices() async {
    try {
      _prices = await _priceService.obtenerPrecios();
      notifyListeners();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> addPrice(Map<String, dynamic> price) async {
    try {
      await _priceService.registrarPrecio(
        price['planType'],
        price['planPrice'],
        price['company'],
        price['licenseQuantity'],
        price['contractTime'],
        price['finalPrice'],
      );
      fetchPrices();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> updatePrice(Map<String, dynamic> price) async {
    try {
      await _priceService.actualizarPrecio(
        price['id'],
        price['planType'],
        price['planPrice'],
        price['company'],
        price['licenseQuantity'],
        price['contractTime'],
        price['finalPrice'],
      );
      fetchPrices();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> deletePrice(String id) async {
    try {
      await _priceService.eliminarPrecio(id);
      fetchPrices();
    } catch (e) {
      // Manejar error
    }
  }
}
