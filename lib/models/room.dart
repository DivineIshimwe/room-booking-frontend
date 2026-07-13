class Room {
  final int id;
  final String name;
  final double price;
  final String status;

  Room({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      status: json['status'],
    );
  }
}