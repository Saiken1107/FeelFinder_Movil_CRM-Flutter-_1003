// models/opportunity.dart
class Opportunity {
  final String id;
  final String name;
  final double probability;
  final String status;

  Opportunity(
      {required this.id,
      required this.name,
      required this.probability,
      required this.status});
}
