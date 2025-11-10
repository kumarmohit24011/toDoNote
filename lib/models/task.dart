class Task {
  String id;
  String title;
  bool isCompleted;
  DateTime? dueDate;
  bool isImportant;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.isImportant = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'dueDate': dueDate?.toIso8601String(),
        'isImportant': isImportant,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        isImportant: json['isImportant'] ?? false,
      );
}
