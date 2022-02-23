import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipper/model/user_model.dart';
import 'package:shipper/screen/bottom_navigation_screen.dart';
import 'package:shipper/screen/home_admin_screen.dart';
import 'package:shipper/screen/login_screen.dart';

List<String> listStartNumber = [
  '086',
  '096',
  '097',
  '098',
  '032',
  '033',
  '034',
  '035',
  '036',
  '037',
  '038',
  '039',
  '091',
  '094',
  '083',
  '084',
  '085',
  '081',
  '082',
  '090',
  '093',
  '0120',
  '0121',
  '0122',
  '0126',
  '0128',
  '08966',
  '092',
  '056',
  '058',
  '079',
  '087',
  '077'
];

const String KEY_LOGIN = 'KEY_LOGIN';
const String KEY_ADMIN = 'KEY_ADMIN';
const String KEY_USER = 'KEY_USER';
const String KEY_ADD_NOTE = 'KEY_ADD_NOTE';

StreamSubscription setTimeout(Function callback, int milliseconds) {
  final future = Future.delayed(Duration(milliseconds: milliseconds));
  return future.asStream().listen((event) {}, onDone: () {
    callback();
  });
}

void clearTimeout(StreamSubscription subscription) {
  try {
    subscription.cancel();
  } catch (e) {}
}

String checkPhoneNumber(String value) {
  if (value.isNotEmpty) {
    for (var element in listStartNumber) {
      if (value.contains(element)) {
        int index = value.indexOf(element);
        if (value.length >= index + 10) {
          print('INDEX = $index - INDEX + 5 = ${index + 5}');
          value = value.replaceRange(index, index + 5, '******');
        }
      }
    }
    return value;
  }
  return '';
}

String getPhoneNumber(String value) {
  if (value.isNotEmpty) {
    for (var element in listStartNumber) {
      if (value.contains(element)) {
        int index = value.indexOf(element);
        if (value.length >= index + 10) {
          print('INDEX = $index - INDEX + 5 = ${index + 5}');
          value = value.substring(index, index + 10);
        }
      }
    }
    return value;
  }
  return '';
}

Future<void> checkLogin(bool isAdmin, BuildContext context) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  String? user = prefs.getString(KEY_USER);
  bool? isLogin = user != null && user.isNotEmpty;
  print('IS LOGIN = $isLogin');
  print('IS LOGIN USER = ${(user?.isNotEmpty ?? false)}');
  if (isLogin) {
    if (isAdmin) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeAdminScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomNavigationScreen()));
    }
  } else {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

Future<void> saveData(User? user) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  if (user != null) {
    print('json11 === ${user.toString()}');
    prefs.setString(KEY_USER, user.toString());
  }
}

Future<User> getData() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  String? json = prefs.getString(KEY_USER);
  if (json != null) {
    print('json11 === $json');
    Map<String, dynamic> data = jsonDecode(json);
    print('json === $data');
    User user = User.fromJson(data);
    return user;
  }
  return User();
}

Future<void> setStatusLogin(bool isAdmin, BuildContext context) async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  if (isAdmin) {
    prefs.setBool(KEY_ADMIN, true);
  } else {
    prefs.setBool(KEY_ADMIN, false);
  }
}

Future<bool> getRole() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  bool? isAdmin = prefs.getBool(KEY_ADMIN);
  if (isAdmin == null) {
    return false;
  }
  return isAdmin;
}

Future<void> clearStatusLogin() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setBool(KEY_LOGIN, false);
  prefs.setString(KEY_USER, '');
}
