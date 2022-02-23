import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/model/profile_model.dart';
import 'package:shipper/model/ship_model.dart';
import 'package:shipper/model/user_model.dart';

class Repository {
  Future<ShipModel> getData(bool isFirstCall, {String? minId}) async {
    String url = 'http://103.98.148.95/api/v1/posts/new';
    String url1 =
        'http://103.98.148.95/api/v1/posts/new${minId != null ? '?min_id=$minId' : ''}';
    print('url ${url1}');
    print('token ${LoginController().user?.token}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(
      Uri.parse(isFirstCall ? url : url1),
      headers: {'Authorization': 'Bearer ${LoginController().user?.token}'},
    );
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      ShipModel jsonResponse = ShipModel.fromJson(json.decode(response.body));
      print('Number of books about http: ${jsonResponse.data?.length}.');
      return jsonResponse;
    }

    return ShipModel();
  }

  Future<ShipModel> getNotes() async {
    String url = 'http://103.98.148.95/api/v1/notes/get_all';
    print('url ${url}');
    print('token ${LoginController().user?.token}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${LoginController().user?.token}'},
    );
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      ShipModel jsonResponse = ShipModel.fromJson(json.decode(response.body));
      print('Number of books about http: ${jsonResponse.data?.length}.');
      return jsonResponse;
    }

    return ShipModel();
  }

  Future<ProfileModel> getListUser({int pageNumber = 1}) async {
    String url =
        'http://103.98.148.95/api/v1/admin/users.json?page=$pageNumber';
    print('url ${url}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${LoginController().user?.token}'},
    );
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      ProfileModel jsonResponse =
          ProfileModel.fromJson(json.decode(response.body));
      print('Number of books about http: ${jsonResponse.data?.length}.');
      return jsonResponse;
    }
    return ProfileModel();
  }

  Future<ProfileModel> searchProfile(String value) async {
    String url =
        'http://103.98.148.95/api/v1/admin/users.json?username=$value';
    print('url ${url}');
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${LoginController().user?.token}'},
    );
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      ProfileModel jsonResponse =
          ProfileModel.fromJson(json.decode(response.body));
      print('Number of books about http: ${jsonResponse.data?.length}.');
      return jsonResponse;
    }
    return ProfileModel();
  }

  Future<User> login(String userName, String passWord) async {
    String url = 'http://103.98.148.95/api/v1/auth/login';
    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'username': userName,
      'password': passWord,
    };
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});

    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      User jsonResponse = User.fromJson(json.decode(response.body));
      print('Number of books about http: ${jsonResponse.fullName}.');
      LoginController().user = jsonResponse;
      return jsonResponse;
    }

    return User();
  }

  Future<bool> register(String userName, String passWord, String fullName,
      String phone, String email) async {
    String url = 'http://103.98.148.95/api/v1/user/create';
    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'username': userName,
      'password': passWord,
      'full_name': fullName,
      'email': email,
      'phone': phone,
    };
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});

    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> activeUser(String userName) async {
    String url = 'http://103.98.148.95/api/v1/user/active';

    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'username': userName,
      'expired': '1',
    };
    print('URL = $url');
    print('PARAM = ${LoginController().user?.token}');
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deActiveUser(String userName) async {
    String url = 'http://103.98.148.95/api/v1/user/deactive';

    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'username': userName,
    };
    print('URL = $url');
    print('PARAM = ${LoginController().user?.token}');
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> createNote(String postId, bool isAdd) async {
    String url =
        'http://103.98.148.95/api/v1/notes/${isAdd ? 'create_note' : 'delete_note'}';

    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'post_id': postId,
    };
    print('URL = $url');
    print('PARAM = ${LoginController().user?.token}');
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> warningUser(String facebookID) async {
    String url =
        'http://103.98.148.95/api/v1/black_list/add';

    // Await the http get response, then decode the json-formatted response.
    final queryParameters = {
      'fb_user_post_id': facebookID,
    };
    print('URL = $url');
    print('PARAM = ${LoginController().user?.token}');
    var response = await http.post(
        Uri.parse(url).replace(queryParameters: queryParameters),
        headers: {'Authorization': 'Bearer ${LoginController().user?.token}'});
    print('REPONSE = ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
