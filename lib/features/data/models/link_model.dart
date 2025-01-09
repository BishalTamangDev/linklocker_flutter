class LinkModel {
  int linkId;
  String name;
  String category;
  String emailAddress;
  String note;
  DateTime? dateOfBirth;

//<editor-fold desc="Data Methods">
  LinkModel({
    this.linkId = 0,
    this.name = "",
    this.category = "others",
    this.emailAddress = "",
    DateTime? dateOfBirth,
    this.note = "",
  }) : dateOfBirth = dateOfBirth ?? DateTime.fromMillisecondsSinceEpoch(0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinkModel &&
          runtimeType == other.runtimeType &&
          linkId == other.linkId &&
          name == other.name &&
          category == other.category &&
          emailAddress == other.emailAddress &&
          note == other.note &&
          dateOfBirth == other.dateOfBirth);

  @override
  int get hashCode =>
      linkId.hashCode ^
      name.hashCode ^
      category.hashCode ^
      emailAddress.hashCode ^
      note.hashCode ^
      dateOfBirth.hashCode;

  @override
  String toString() {
    return 'LinkModel{' +
        ' linkId: $linkId,' +
        ' name: $name,' +
        ' category: $category,' +
        ' emailAddress: $emailAddress,' +
        ' note: $note,' +
        ' dateOfBirth: $dateOfBirth,' +
        '}';
  }

  LinkModel copyWith({
    int? linkId,
    String? name,
    String? category,
    String? emailAddress,
    String? note,
    DateTime? dateOfBirth,
  }) {
    return LinkModel(
      linkId: linkId ?? this.linkId,
      name: name ?? this.name,
      category: category ?? this.category,
      emailAddress: emailAddress ?? this.emailAddress,
      note: note ?? this.note,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'linkId': linkId,
      'name': name,
      'category': category,
      'emailAddress': emailAddress,
      'note': note,
      'dateOfBirth': dateOfBirth,
    };
  }

  factory LinkModel.fromMap(Map<String, dynamic> map) {
    return LinkModel(
      linkId: map['linkId'] as int,
      name: map['name'] as String,
      category: map['category'] as String,
      emailAddress: map['emailAddress'] as String,
      note: map['note'] as String,
      dateOfBirth: map['dateOfBirth'] as DateTime,
    );
  }

//</editor-fold>
}
