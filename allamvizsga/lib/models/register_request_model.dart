class RegisterRequestModel {
  String? firstName;
  String? lastName;
  String? email;
  String? userName;
  String? password;
  String? gender;
  String? education;
  String? birthdate;
  int? status;

  RegisterRequestModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.userName,
      this.password,
      this.gender,
      this.education,
      this.birthdate,
      this.status});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    userName = json['userName'];
    password = json['password'];
    gender = json['gender'];
    education = json['education'];
    birthdate = json['birthdate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['education'] = this.education;
    data['birthdate'] = this.birthdate;
    data['status'] = this.status;
    return data;
  }
}
