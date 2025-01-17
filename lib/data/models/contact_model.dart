class ContactModel {
  int contactId;
  int linkId;
  String country;
  String phoneNumber;

//<editor-fold desc="Data Methods">
  ContactModel({
    this.contactId = 0,
    this.linkId = 0,
    this.country = "nepal",
    this.phoneNumber = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactModel &&
          runtimeType == other.runtimeType &&
          contactId == other.contactId &&
          linkId == other.linkId &&
          country == other.country &&
          phoneNumber == other.phoneNumber);

  @override
  int get hashCode =>
      contactId.hashCode ^
      linkId.hashCode ^
      country.hashCode ^
      phoneNumber.hashCode;

  @override
  String toString() {
    return 'ContactModel{' +
        ' contactId: $contactId,' +
        ' linkId: $linkId,' +
        ' country: $country,' +
        ' phoneNumber: $phoneNumber,' +
        '}';
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'linkId': linkId,
      'country': country,
      'phoneNumber': phoneNumber,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      contactId: map['contactId'] as int,
      linkId: map['linkId'] as int,
      country: map['country'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }

//</editor-fold>
}
