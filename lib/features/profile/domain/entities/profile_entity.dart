import 'dart:typed_data';

class ProfileEntity {
  int? id;
  String? name;
  String? email;
  Uint8List? profilePicture;

  ProfileEntity({this.id, this.name, this.email, this.profilePicture});
}
