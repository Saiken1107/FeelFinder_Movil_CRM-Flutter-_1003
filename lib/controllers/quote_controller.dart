import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class QuoteController extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();
  List<Map<String, dynamic>> _quotes = [];

  List<Map<String, dynamic>> get quotes => _quotes;

  Future<void> fetchQuotes() async {
    try {
      _quotes = await _quoteService.obtenerCotizaciones();
      notifyListeners();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> addQuote(Map<String, dynamic> quote) async {
    try {
      await _quoteService.registrarCotizacion(
        quote['clientName'],
        quote['licenseQuantity'],
        quote['planType'],
        quote['planPrice'],
      );
      fetchQuotes();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> updateQuote(Map<String, dynamic> quote) async {
    try {
      await _quoteService.actualizarCotizacion(
        quote['id'],
        quote['clientName'],
        quote['licenseQuantity'],
        quote['planType'],
        quote['planPrice'],
      );
      fetchQuotes();
    } catch (e) {
      // Manejar error
    }
  }

  Future<void> deleteQuote(String id) async {
    try {
      await _quoteService.eliminarCotizacion(id);
      fetchQuotes();
    } catch (e) {
      // Manejar error
    }
  }
}
