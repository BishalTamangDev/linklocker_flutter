import 'package:linklocker/core/constants/app_constants.dart';

import '../../domain/entities/profile_contact_entity.dart';

class ProfileContactModel extends ProfileContactEntity {
  ProfileContactModel(
      {required super.contactId,
      required super.country,
      required super.contactNumber});

// from entity
  factory ProfileContactModel.fromEntity(
      ProfileContactEntity profileContactEntity) {
    return ProfileContactModel(
        contactId: profileContactEntity.contactId,
        country: profileContactEntity.country,
        contactNumber: profileContactEntity.contactNumber);
  }

  // to entity
  ProfileContactEntity toEntity() {
    return ProfileContactEntity(
        contactId: contactId ?? 0,
        country: country ?? AppConstants.defaultCountry,
        contactNumber: contactNumber ?? '');
  }

// from map
  factory ProfileContactModel.fromMap(Map<String, dynamic> map) {
    return ProfileContactModel(
        contactId: map['user_contact_id'] ?? 0,
        country: map['country'] ?? AppConstants.defaultCountry,
        contactNumber: map['contact'] ?? '');
  }

// to map
  Map<String, dynamic> toMap() {
    return {
      'user_contact_id': contactId,
      'country': country,
      'contact': contactNumber
    };
  }

// to string
  @override
  String toString() {
    return "ContactModel{contactId: $contactId, country: $country,  contactNumber: $contactNumber}";
  }

// data to upload
  Map<String, dynamic> dataToUpload() {
    return {
      'country': country ?? AppConstants.defaultCountry,
      'contact': contactNumber ?? ''
    };
  }
}
