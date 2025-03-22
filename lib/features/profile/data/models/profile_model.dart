import 'dart:typed_data';

import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.profilePicture});

  // to map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "profile_picture": profilePicture
    };
  }

  // from map
  factory ProfileModel.fromMap(ProfileEntity map) {
    return ProfileModel(
        id: map.id,
        name: map.name,
        email: map.email,
        profilePicture: map.profilePicture);
  }

  // from entity
  factory ProfileModel.fromEntity(ProfileEntity profileEntity) {
    return ProfileModel(
        id: profileEntity.id,
        name: profileEntity.name,
        email: profileEntity.email,
        profilePicture: profileEntity.profilePicture);
  }

  // copy with
  ProfileModel copyWith(
      {int? id, String? name, String? email, Uint8List? profilePicture}) {
    return ProfileModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        profilePicture: profilePicture ?? this.profilePicture);
  }

  @override
  String toString() {
    return "UserModel{id: $id, name: $name, email: $email, profilePicture: $profilePicture}";
  }
}
