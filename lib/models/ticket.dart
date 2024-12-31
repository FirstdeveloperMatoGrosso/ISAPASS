class Ticket {
  final String id;
  final String type;
  final double price;
  final bool isUsed;
  final DateTime createdAt;
  final DateTime? usedAt;

  Ticket({
    required this.id,
    required this.type,
    required this.price,
    this.isUsed = false,
    required this.createdAt,
    this.usedAt,
  });
}
