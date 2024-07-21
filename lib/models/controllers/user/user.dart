

class UserModel{
  String uId;
  String name;
  String email;
  String bio;
  String image;
  String phoneNumber;
  String dateOfBirth;
  String gender;

//<editor-fold desc="Data Methods">
  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.bio,
    required this.image,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          uId == other.uId &&
          name == other.name &&
          email == other.email &&
          bio == other.bio &&
          image == other.image &&
          phoneNumber == other.phoneNumber &&
          dateOfBirth == other.dateOfBirth &&
          gender == other.gender);

  @override
  int get hashCode =>
      uId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      bio.hashCode ^
      image.hashCode ^
      phoneNumber.hashCode ^
      dateOfBirth.hashCode ^
      gender.hashCode;

  @override
  String toString() {
    return "UserModel{ uId: $uId, name: $name, email: $email, bio: $bio, image: $image, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, gender: $gender,}";
  }

  UserModel copyWith({
    String? uId,
    String? name,
    String? email,
    String? bio,
    String? image,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'bio': bio,
      'image': image,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      image: map['image'] as String,
      phoneNumber: map['phoneNumber'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      gender: map['gender'] as String,
    );
  }

//</editor-fold>
}