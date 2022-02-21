class ProfileModel {
  final List<DataProfile>? data;

  ProfileModel({this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => DataProfile.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data?.map((v) => v.toJson()).toList();
    return data;
  }
}

class DataProfile {
  final Profile? attributes;
  final String? id;
  final String? type;

  DataProfile({this.attributes, this.id, this.type});

  factory DataProfile.fromJson(Map<String, dynamic> json) {
    return DataProfile(
      attributes: json['attributes'] != null
          ? Profile.fromJson(json['attributes'])
          : null,
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes?.toJson();
    }
    return data;
  }
}

class Profile {
  final String? email;
  final String? fullName;
  String? status;
  final String? type;
  final String? phone;
  final String? userName;

  Profile(
      {this.email,
      this.fullName,
      this.status,
      this.type,
      this.phone,
      this.userName});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      fullName: json['full_name'],
      status: json['get_status'],
      type: json['get_type'],
      phone: json['phone'],
      userName: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['full_name'] = fullName;
    data['get_status'] = status;
    data['get_type'] = type;
    data['phone'] = phone;
    data['username'] = userName;
    return data;
  }
}
