import 'dart:typed_data';

class LinkModel {
  int linkId;
  String name;
  String category;
  String emailAddress;
  String note;
  DateTime? dateOfBirth;
  Uint8List? profilePicture;

//<editor-fold desc="Data Methods">
  LinkModel({
    this.linkId = 0,
    this.name = "",
    this.category = "other",
    this.emailAddress = "",
    this.note = "",
    this.dateOfBirth,
    this.profilePicture,
  });

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
          dateOfBirth == other.dateOfBirth &&
          profilePicture == other.profilePicture);

  @override
  int get hashCode =>
      linkId.hashCode ^
      name.hashCode ^
      category.hashCode ^
      emailAddress.hashCode ^
      note.hashCode ^
      dateOfBirth.hashCode ^
      profilePicture.hashCode;

  @override
  String toString() {
    return 'LinkModel{' +
        ' linkId: $linkId,' +
        ' name: $name,' +
        ' category: $category,' +
        ' emailAddress: $emailAddress,' +
        ' note: $note,' +
        ' dateOfBirth: $dateOfBirth,' +
        ' profilePicture: $profilePicture,' +
        '}';
  }

  LinkModel copyWith({
    int? linkId,
    String? name,
    String? category,
    String? emailAddress,
    String? note,
    DateTime? dateOfBirth,
    Uint8List? profilePicture,
  }) {
    return LinkModel(
      linkId: linkId ?? this.linkId,
      name: name ?? this.name,
      category: category ?? this.category,
      emailAddress: emailAddress ?? this.emailAddress,
      note: note ?? this.note,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePicture: profilePicture ?? this.profilePicture,
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
      'profilePicture': profilePicture,
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
      profilePicture: map['profilePicture'] as Uint8List,
    );
  }

//</editor-fold>
}
