import 'package:flutter/material.dart';

import '../constance.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 3000), () async{
      bool isAdmin = await getRole();
      await checkLogin(isAdmin, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/img_logo.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                ),
                const Text(
                  'Công ty Cổ Phần Thương Mại Và Dịch Vụ Moca Việt Nam\n Hotline: 0523.858.858',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.bold),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          const Positioned(
            child:  Text(
              'Địa chỉ:\n+ Chi nhánh phía Bắc: số 18, 402/7 đường Mỹ Đình, quận Nam Từ Liêm, Hà Nội\n+Chi nhánh phía Nam: 82/25,Lê Văn Qưới, Bình Hưng Hoà A,Bình Tân, Tp.HCM',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.bold),
            ),
            bottom: 20,
            left: 16,
            right: 16,
          )
        ],
      ),
    );
  }
}
