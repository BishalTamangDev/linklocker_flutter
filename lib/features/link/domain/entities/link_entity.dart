import 'dart:typed_data';

import '../../../../core/constants/app_constants.dart';

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
