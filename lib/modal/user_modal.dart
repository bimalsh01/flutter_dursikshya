class UserModal {
  String? firstname;
  String? lastname;
  String? email;
  String? username;

  UserModal({this.firstname, this.lastname, this.email, this.username});

  // convert firebase firestore data to dart object
  UserModal fromJson(Map<String, dynamic> json) {
    return UserModal(
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
    };
  }
}
