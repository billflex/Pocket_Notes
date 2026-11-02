class ScheduleEntry {
  final int? id;
  final String subject;
  final String room;

  const ScheduleEntry({this.id, required this.subject, required this.room});

  // Turns this object into a Map so sqflite can save it as a row.
  Map<String, Object?> toMap() {
    return {if (id != null) 'id': id, 'subject': subject, 'room': room};
  }

  // Turns a row from the database back into a ScheduleEntry.
  factory ScheduleEntry.fromMap(Map<String, Object?> map) {
    return ScheduleEntry(
      id: map['id'] as int?,
      subject: map['subject'] as String,
      room: map['room'] as String,
    );
  }
}
