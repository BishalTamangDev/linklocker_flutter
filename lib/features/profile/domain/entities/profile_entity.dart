import 'dart:typed_data';

class ProfileEntity {
  int? id;
  String? name;
  String? emailAddress;
  Uint8List? profilePicture;

  ProfileEntity({this.id, this.name, this.emailAddress, this.profilePicture});
}
