class Event {
  final String id;
  final String name;
  final String location;
  final DateTime date;
  final String imageUrl;
  final String description;
  final double price;
  final String organizer;

  const Event({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.organizer,
  });

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  String get formattedPrice {
    return 'R\$ ${price.toStringAsFixed(2)}';
  }
}
