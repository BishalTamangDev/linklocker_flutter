import 'dart:typed_data';

class UserModel {
  int? id;
  String? name;
  String? email;
  Uint8List? profilePicture;

//   getters
  get getId => id;

  get getName => name;

  get getEmail => email;

  get getProfilePicture => profilePicture ?? Uint8List(0);

//   setters
  set setId(int newId) {
    id = newId;
  }

  set setName(String newName) {
    name = newName;
  }

  set setEmail(String newEmail) {
    email = newEmail;
  }

  set setProfilePicture(Uint8List picture) {
    profilePicture = picture;
  }

//<editor-fold desc="Data Methods">
  UserModel({
    this.id = 0,
    this.name = "",
    this.email = "",
    Uint8List? profilePic,
  }) : profilePicture = profilePic ?? Uint8List(0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          profilePicture == other.profilePicture);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ email.hashCode ^ profilePicture.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' email: $email,' +
        ' profilePicture: $profilePicture,' +
        '}';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    Uint8List? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePic: map['profilePicture'] as Uint8List,
    );
  }

//</editor-fold>
}
