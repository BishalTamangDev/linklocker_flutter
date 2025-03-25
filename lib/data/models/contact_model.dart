class ContactModel {
  int contactId;
  int linkId;
  String country;
  String contactNumber;

  ContactModel({
    this.contactId = 0,
    this.linkId = 0,
    this.country = "nepal",
    this.contactNumber = "",
  });

  @override
  String toString() {
    return 'ContactModel{contactId: $contactId, linkId: $linkId, country: $country,phoneNumber: $contactNumber }';
  }

  ContactModel copyWith({
    int? contactId,
    int? linkId,
    String? country,
    String? phoneNumber,
  }) {
    return ContactModel(
      contactId: contactId ?? this.contactId,
      linkId: linkId ?? this.linkId,
      country: country ?? this.country,
      contactNumber: phoneNumber ?? contactNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'linkId': linkId,
      'country': country,
      'phoneNumber': contactNumber,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      contactId: map['contactId'] as int,
      linkId: map['linkId'] as int,
      country: map['country'] as String,
      contactNumber: map['phoneNumber'] as String,
    );
  }
}
