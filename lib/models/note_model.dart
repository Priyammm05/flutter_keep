class NotesVariable {
  static const String id = 'id';
  static const String uniqueID = 'uniqueID';
  static const String pin = 'pin';
  static const String isArchive = 'isArchive';
  static const String title = 'title';
  static const String content = 'content';
  static const String createdTime = 'createdTime';
  static const String table = 'Notes';

  static final List<String> values = [
    id,
    uniqueID,
    pin,
    isArchive,
    title,
    content,
    createdTime,
  ];
}

class Note {
  final int? id;
  final String? uniqueID;
  final bool pin;
  final bool isArchive;
  final String title;
  final String content;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.uniqueID,
    required this.pin,
    required this.isArchive,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  Note copy({
    int? id,
    String? uniqueID,
    bool? pin,
    bool? isArchive,
    String? title,
    String? content,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      uniqueID: uniqueID ?? this.uniqueID,
      pin: pin ?? this.pin,
      isArchive: isArchive ?? this.isArchive,
      title: title ?? this.title,
      content: content ?? this.content,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static Note fromJson(Map<String, Object?> json) {
    return Note(
      id: json[NotesVariable.id] as int?,
      uniqueID: json[NotesVariable.uniqueID] as String,
      pin: json[NotesVariable.pin] == 1,
      isArchive: json[NotesVariable.isArchive] == 1,
      title: json[NotesVariable.title] as String,
      content: json[NotesVariable.content] as String,
      createdTime: DateTime.parse(json[NotesVariable.createdTime] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      NotesVariable.id: id,
      NotesVariable.uniqueID: uniqueID,
      NotesVariable.pin: pin ? 1 : 0,
      NotesVariable.isArchive: isArchive ? 1 : 0,
      NotesVariable.title: title,
      NotesVariable.content: content,
      NotesVariable.createdTime: createdTime.toIso8601String(),
    };
  }
}
