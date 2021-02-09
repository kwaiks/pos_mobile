class UserStore {
  int id;
  String storeName;

  UserStore.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int ? json['id'] : int.parse(json['id']),
        storeName = json['storeName'];

  Map<String, dynamic> toJson() => {"id": id, "storeName": storeName};
}

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String profilePicture;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phoneNumber'],
        profilePicture = json['profilePicture'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "lastName": lastName,
        "firstName": firstName,
        "phoneNumber": phoneNumber,
        "profilePicture": profilePicture
      };
}
