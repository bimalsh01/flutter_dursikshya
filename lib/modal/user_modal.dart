class UserModal {
  String? firstname;
  String? lastname;
  String? email;
  String? username;
  String? profile;

  UserModal({this.firstname, this.lastname, this.email, this.username, this.profile});

  // convert firebase firestore data to dart object
  UserModal fromJson(Map<String, dynamic> json) {
    return UserModal(
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        username: json['username'],
        profile: json['profile']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
      'profile': profile
    };
  }
}
