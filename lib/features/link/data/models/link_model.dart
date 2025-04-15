import 'dart:typed_data';

import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

class LinkModel extends LinkEntity {
  LinkModel({
    required super.linkId,
    required super.name,
    required super.category,
    required super.emailAddress,
    required super.note,
    required super.dateOfBirth,
    required super.profilePicture,
  });

  // from map
  factory LinkModel.fromMap(Map<String, dynamic> map) {
    return LinkModel(
      linkId: map['link_id'] ?? 0,
      name: map['name'] ?? '',
      category: map['category'] != null && map['category'] != '' ? LinkCategoryEnum.getCategoryFromLabel(map['category']) : LinkCategoryEnum.other,
      emailAddress: map['email_address'] ?? '',
      note: map['note'] ?? '',
      dateOfBirth: map['date_of_birth'] != null && map['date_of_birth'] != '' ? DateTime.parse(map['date_of_birth']) : null,
      profilePicture: map['profile_picture'] ?? Uint8List(0),
    );
  }

  // to map
  Map<String, dynamic> toMap({bool uploadingData = false}) {
    Map<String, dynamic> data = {
      'name': name ?? '',
      'category': category!.label,
      'email_address': emailAddress ?? '',
      'note': note ?? '',
      'date_of_birth': dateOfBirth != null ? dateOfBirth!.toString() : '',
      'profile_picture': profilePicture,
    };

    if (!uploadingData) {
      data['link_id'] = linkId;
    }

    return data;
  }

  // from entity
  factory LinkModel.fromEntity(LinkEntity linkEntity) {
    return LinkModel(
      linkId: linkEntity.linkId,
      name: linkEntity.name,
      category: linkEntity.category,
      emailAddress: linkEntity.emailAddress,
      note: linkEntity.note,
      dateOfBirth: linkEntity.dateOfBirth,
      profilePicture: linkEntity.profilePicture,
    );
  }

  // to entity
  LinkEntity toEntity() {
    return LinkEntity(
      linkId: linkId,
      name: name,
      category: category,
      profilePicture: profilePicture,
      emailAddress: emailAddress,
      dateOfBirth: dateOfBirth,
      note: note,
    );
  }

  // to string
  @override
  String toString() {
    return "LinkModel{linkId: $linkId, name: $name, category: $category, emailAddress: $emailAddress, dateOfBirth: $dateOfBirth, note: $note, profilePicture: $profilePicture}";
  }
}
