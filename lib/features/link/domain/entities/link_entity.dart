import 'dart:typed_data';

import '../../../../core/constants/link_category_enum.dart';

class LinkEntity {
  int? linkId;
  String? name;
  LinkCategoryEnum? category;
  String? emailAddress;
  String? note;
  DateTime? dateOfBirth;
  Uint8List? profilePicture;

  // constructor
  LinkEntity({
    this.linkId,
    this.name,
    this.category,
    this.emailAddress,
    this.note,
    this.dateOfBirth,
    this.profilePicture,
  });
}
