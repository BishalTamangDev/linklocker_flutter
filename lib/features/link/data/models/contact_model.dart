import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    required super.contactId,
    required super.linkId,
    required super.country,
    required super.number,
  });

  // from map
  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      contactId: map['contact_id'] ?? 0,
      linkId: map['link_id'] ?? 0,
      country: map['country'] ?? AppConstants.defaultCountry,
      number: map['number'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap({bool uploadingData = false}) {
    Map<String, dynamic> data = {
      'country': country,
      'number': number,
    };
    if (!uploadingData) {
      data['contact_id'] = contactId;
      data['link_id'] = linkId;
    } else {
      data['link_id'] = 0;
    }
    return data;
  }

  // from entity
  factory ContactModel.fromEntity(ContactEntity contactEntity) {
    return ContactModel(
      contactId: contactEntity.contactId,
      linkId: contactEntity.linkId,
      country: contactEntity.country,
      number: contactEntity.number,
    );
  }

  // to entity
  ContactEntity toEntity() {
    return ContactEntity(
      linkId: linkId,
      contactId: contactId,
      country: country,
      number: number,
    );
  }

  // to String
  @override
  String toString() => "ContactModel{linkId: $linkId, contactId: $contactId, country: $country, number: $number}";
}
