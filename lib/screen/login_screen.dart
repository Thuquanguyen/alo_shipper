import 'package:flutter/material.dart';
import 'package:shipper/constance.dart';
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/network/repository.dart';
import 'package:shipper/screen/bottom_navigation_screen.dart';
import 'package:shipper/screen/home_admin_screen.dart';
import 'package:shipper/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final userNameController = TextEditingController(text: '0969551162');
  // final passWordController = TextEditingController(text: '1');
  //
  // final userNameController = TextEditingController(text: '0961356965');
  // final passWordController = TextEditingController(text: '1');

  // final userNameController = TextEditingController(text: 'admin');
  // final passWordController = TextEditingController(text: '123123');

  final userNameController = TextEditingController(text: '');
  final passWordController = TextEditingController(text: '');
  bool isShowLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).focusScopeNode.unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Spacer(),
                      Image.asset(
                        'assets/images/img_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: TextField(
                                controller: userNameController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Số điện thoại",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passWordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Mật khẩu",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text('Bạn chưa có tài khoản?'),
                          GestureDetector(
                            child: const Text(' Đăng ký ngay!',
                                style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      GestureDetector(
                        onTap: () {
                          String userName = userNameController.text.trim();
                          String passWord = passWordController.text.trim();
                          if (userName.isEmpty || passWord.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      title: Text('Thông báo'),
                                      content: Text(
                                          'Tài khoản hoặc mật khẩu không được để trống!'),
                                    ));
                          } else {
                            setState(() {
                              isShowLoading = true;
                            });
                            Repository()
                                .login(userName, passWord)
                                .then((value) async {
                              setState(() {
                                isShowLoading = false;
                              });
                              if (value.username?.isNotEmpty ?? false) {
                                if (userName == '0961356965' &&
                                    passWord == '1') {
                                  await setStatusLogin(true, context);
                                  await saveData(LoginController().user);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeAdminScreen()));
                                } else {
                                  await setStatusLogin(false, context);
                                  await saveData(LoginController().user);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigationScreen()));
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
                                          title: Text('Thông báo'),
                                          content: Text(
                                              'Tài khoản hoặc mật khẩu không chính xác! Vui lòng kiểm tra lại'),
                                        ));
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: const Center(
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              if (isShowLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          )),
    );
  }
}
