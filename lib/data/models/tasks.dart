class Tasks {
  final int? id;
  late final String title;
  late final String? description;
  final DateTime? created_at;
  final DateTime? due_date;
  final String status;
  final String? image_path;

  Tasks({
    this.id,
    required this.title,
    this.status = 'đang hoàn thành',
    this.description,
    this.image_path,
    this.due_date,
    this.created_at,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'created_at': created_at?.millisecondsSinceEpoch,
      'due_date': due_date?.millisecondsSinceEpoch,
      'status': status,
      'image_path': image_path,
    };
    map['id'] = id;
    return map;
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      due_date:
          map['due_date'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['due_date'])
              : null,
      status: map['status'],
      // categories: map['categories'],
      image_path: map['image_path'],
    );
  }

  Tasks copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    String? status,
    int? priority,
    String? imagePath,
    int? is_repeat,
    DateTime? repeat_days,
  }) {
    return Tasks(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      created_at: createdAt ?? this.created_at,
      due_date: dueDate ?? this.due_date,
      status: status ?? this.status,
      image_path: imagePath ?? this.image_path,
    );
  }
}
