import 'package:flutter/material.dart';
import 'package:shipper/network/repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userNameController = TextEditingController(text: '');
  final passWordController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final fullNameController = TextEditingController(text: '');

  bool isShowLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).focusScopeNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Đăng ký',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black)),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/img_logo.jpg',
                        fit: BoxFit.cover,
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
                                    hintText: "Số điện thoại(*)",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: TextField(
                                controller: passWordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Mật khẩu(*)",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: TextField(
                                controller: fullNameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Họ và tên(*)",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.all(8.0),
                            //   decoration: BoxDecoration(
                            //       border: Border(
                            //           bottom: BorderSide(
                            //               color: Colors.grey.shade100))),
                            //   child: TextField(
                            //     controller: phoneController,
                            //     keyboardType: TextInputType.number,
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: "Số điện thoại(*)",
                            //         hintStyle:
                            //             TextStyle(color: Colors.grey[400])),
                            //   ),
                            // ),
                            // Container(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextField(
                            //     keyboardType: TextInputType.emailAddress,
                            //     controller: emailController,
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: "Email(*)",
                            //         hintStyle:
                            //             TextStyle(color: Colors.grey[400])),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          String userName = userNameController.text.trim();
                          String passWord = passWordController.text.trim();
                          String fullName = fullNameController.text.trim();
                          String phone = '';
                          String email = '';

                          if (userName.isEmpty ||
                              passWord.isEmpty ||
                              fullName.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                      title: Text('Thông báo'),
                                      content: Text(
                                          'Trường dữ liệu không được để trống!'),
                                    ));
                          } else {
                            setState(() {
                              isShowLoading = true;
                            });
                            Repository()
                                .register(
                                    userName, passWord, fullName, phone, email)
                                .then((value) {
                              setState(() {
                                isShowLoading = false;
                              });
                              if (value) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text('Thông báo'),
                                          content:
                                              const Text('Đăng ký thành công!'),
                                          actions: [
                                            GestureDetector(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                                width: 100,
                                                height: 40,
                                                child: const Center(
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                    barrierDismissible: false);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
                                          title: Text('Thông báo'),
                                          content: Text(
                                              'Đăng ký thất bại! Vui lòng thử tên đăng nhập khác.'),
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
                              "Đăng ký",
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
          ),
        ));
  }
}
