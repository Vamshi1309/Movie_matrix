class UserModel {
  final int? id;
  final String name;
  final String email;
  final String mobileNumber;

  UserModel(
      {this.id,
      required this.name,
      required this.email,
      required this.mobileNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        mobileNumber: json['mobileNumber']);
  }
}
