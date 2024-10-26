// lib/models/quote_model.dart
class Quote {
  final String id;
  final String productLicense;
  final int quantity;
  final double price;
  final String clientName;

  Quote({
    required this.id,
    required this.productLicense,
    required this.quantity,
    required this.price,
    required this.clientName,
  });
}
