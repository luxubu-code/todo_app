class Recurring {
  final int id;
  final int task_id;
  final String repeat_type;
  final int repeat_interval;
  final DateTime start_date;
  final DateTime end_date;

  Recurring({
    required this.id,
    required this.task_id,
    required this.repeat_type,
    required this.repeat_interval,
    required this.start_date,
    required this.end_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': task_id,
      'repeat_type': repeat_type,
      'repeat_interval': repeat_interval,
      'start_date': start_date.millisecondsSinceEpoch,
      'end_date': end_date.millisecondsSinceEpoch,
    };
  }

  factory Recurring.fromMap(Map<String, dynamic> map) {
    return Recurring(
      id: map['id'],
      task_id: map['task_id'],
      repeat_type: map['repeat_type'],
      repeat_interval: map['repeat_interval'],
      start_date: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      end_date: DateTime.fromMillisecondsSinceEpoch(map['end_date']),
    );
  }
}
