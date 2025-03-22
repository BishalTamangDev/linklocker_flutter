import 'dart:typed_data';

class ProfileEntity {
  int id;
  String name;
  String email;
  Uint8List profilePicture;

  ProfileEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.profilePicture});
}
