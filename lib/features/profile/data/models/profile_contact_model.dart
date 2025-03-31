import 'package:linklocker/core/constants/app_constants.dart';

import '../../domain/entities/profile_contact_entity.dart';

class ProfileContactModel extends ProfileContactEntity {
  ProfileContactModel({
    required super.contactId,
    required super.profileId,
    required super.country,
    required super.number,
  });

  // from entity
  factory ProfileContactModel.fromEntity(ProfileContactEntity profileContactEntity) {
    return ProfileContactModel(
      contactId: profileContactEntity.contactId,
      profileId: profileContactEntity.profileId,
      country: profileContactEntity.country,
      number: profileContactEntity.number,
    );
  }

  // to entity
  ProfileContactEntity toEntity() {
    return ProfileContactEntity(
      contactId: contactId ?? 0,
      profileId: profileId ?? 0,
      country: country ?? AppConstants.defaultCountry,
      number: number ?? '',
    );
  }

  // from map
  factory ProfileContactModel.fromMap(Map<String, dynamic> map) {
    return ProfileContactModel(
      contactId: map['contact_id'] ?? 0,
      profileId: map['profile_id'] ?? 0,
      country: map['country'] ?? AppConstants.defaultCountry,
      number: map['number'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'contact_id': contactId,
      'profile_id': profileId,
      'country': country,
      'number': number,
    };
  }

  // to string
  @override
  String toString() {
    return "ContactModel{contactId: $contactId, profileId: $profileId, country: $country, number: $number}";
  }

  // data to upload
  Map<String, dynamic> dataToUpload(int profileId) {
    return {
      'profile_id': profileId ?? 0,
      'country': country ?? AppConstants.defaultCountry,
      'number': number ?? '',
    };
  }
}
