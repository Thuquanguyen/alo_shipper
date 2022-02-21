class User {
  final String? email;
  final String? fullName;
  final String? phone;
  final String? status; // 'NORMAL' - 'ACTIVE'
  final String? token;
  final String? username;

  User(
      {this.email,
      this.fullName,
      this.phone,
      this.status,
      this.token,
      this.username});


  @override
  String toString() {
    return '{"email": "$email", "full_name": "$fullName", "phone": "$phone", "status": "$status", "token": "$token", "username": "$username"}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      fullName: json['full_name'],
      phone: json['phone'],
      status: json['status'],
      token: json['token'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['status'] = status;
    data['token'] = token;
    data['username'] = username;
    return data;
  }
}
