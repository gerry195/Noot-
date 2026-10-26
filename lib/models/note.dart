class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.tone,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final String category;

  /// Indeks warna di `kTones`.
  final int tone;

  /// 0 = Rendah, 1 = Sedang, 2 = Tinggi.
  final int priority;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category,
        'tone': tone,
        'priority': priority,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        category: json['category'] as String,
        tone: json['tone'] as int,
        priority: json['priority'] as int,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      );
}
