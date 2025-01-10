class UserModel {
  int? id;
  String? name;
  String? email;

//   getters
  get getId => id;

  get getName => name;

  get getEmail => email;

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

//<editor-fold desc="Data Methods">
  UserModel({
    this.id = 0,
    this.name = "",
    this.email = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User{' + ' id: $id,' + ' name: $name,' + ' email: $email,' + '}';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

//</editor-fold>
}
