import 'dart:typed_data';

import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.emailAddress,
    required super.profilePicture,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      "profile_id": id,
      "name": name,
      "email_address": emailAddress,
      "profile_picture": profilePicture,
    };
  }

  // from map
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['profile_id'] ?? 0,
      name: map['name'] ?? '',
      emailAddress: map['email_address'] ?? '',
      profilePicture: map['profile_picture'] ?? Uint8List(0),
    );
  }

  // from entity
  factory ProfileModel.fromEntity(ProfileEntity profileEntity) {
    return ProfileModel(
      id: profileEntity.id,
      name: profileEntity.name,
      emailAddress: profileEntity.emailAddress,
      profilePicture: profileEntity.profilePicture,
    );
  }

  // to entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      emailAddress: emailAddress,
      profilePicture: profilePicture,
    );
  }

  // copy with
  ProfileModel copyWith({
    int? id,
    String? name,
    String? emailAddress,
    Uint8List? profilePicture,
  }) {
    return ProfileModel(
      id: id ?? id,
      name: name ?? name,
      emailAddress: emailAddress ?? emailAddress,
      profilePicture: profilePicture ?? profilePicture,
    );
  }

  // to string
  @override
  String toString() {
    return "ProfileModel{id: $id, name: $name, emailAddress: $emailAddress, profilePicture: $profilePicture}";
  }

  // get upload data
  Map<String, dynamic> get profileDataToUpload {
    return {
      'name': name ?? '',
      'email_address': emailAddress ?? '',
      'profile_picture': profilePicture ?? Uint8List(0),
    };
  }
}
