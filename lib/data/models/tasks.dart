class Tasks {
  final int? id;
  final String title;
  final String? description;
  final DateTime? created_at;
  final DateTime? due_date;
  final String status;
  final String? image_path;
  // final List<Categories>? categories;

  Tasks({
    this.id,
    required this.title,
    required this.status,
    this.description,
    this.image_path,
    this.due_date,
    this.created_at,
    // this.categories,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'created_at': created_at?.millisecondsSinceEpoch,
      'due_date': due_date?.millisecondsSinceEpoch,
      'status': status,
      // 'categories': categories,
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
