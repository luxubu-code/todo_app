

class Categories {
  final int? id;
  final String? title;
  final int? color;

  Categories({this.id, this.title, this.color});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'color': color};
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(id: map['id'], title: map['title'], color: map['color']);
  }
}
