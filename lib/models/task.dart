class Task {
  String id;
  String title;
  bool isCompleted;
  DateTime? dueDate;

  Task({required this.id, required this.title, this.isCompleted = false, this.dueDate});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'dueDate': dueDate?.toIso8601String(),
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      );
}
