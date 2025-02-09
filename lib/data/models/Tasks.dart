class Tasks {
  final int id;
  final String title;
  final String? description;
  final DateTime? created_at;
  final DateTime? due_date;
  final int status;
  final String? priority;
  final String? image_path;

  Tasks({
    required this.id,
    required this.title,
    required this.status,
    this.description,
    this.priority,
    this.image_path,
    this.due_date,
    this.created_at,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'created_at': created_at,
      'due_date': due_date?.millisecondsSinceEpoch,
      'status': status,
      'priority': priority,
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
      due_date: map['due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due_date'])
          : null,
      status: map['status'],
      priority: map['priority'],
      image_path: map['image_path'],
    );
  }
}
