class Broadcast {
  final String title;
  final String body;
  final DateTime date;
  final String category;

  Broadcast({
    required this.title,
    required this.body,
    required this.date,
    required this.category,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }
}
