
import 'package:shipper/model/user_model.dart';

class LoginController{
  static final LoginController _loginController = LoginController._internal();

  factory LoginController(){
    return _loginController;
  }

  LoginController._internal();

  User? user;

}