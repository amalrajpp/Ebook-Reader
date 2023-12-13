// Define a DiaryEntry class that contains the fields you want to store
class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final DateTime entryDate;

  // Constructor for the DiaryEntry class
  DiaryEntry(
      {this.id,
      required this.title,
      required this.content,
      required this.entryDate});

  // Convert a DiaryEntry object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'entryDate': entryDate.toIso8601String(),
    };
  }

  // Convert a Map object into a DiaryEntry object
  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      entryDate: DateTime.parse(map['entryDate']),
    );
  }
}
