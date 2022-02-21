import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close, color: Colors.black),
            )
          ],
          title: const Text(
            'Kích hoạt tài khoản',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "Phí gia hạn mỗi tháng 100.000 VNĐ, shiper sẽ được sử dụng đầy đủ các chức năng của phần mềm",
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                      height: 1.5,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Chủ tài khoản : TRẦN NGỌC THUÂN",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "NGUYEN VAN A")).then((_){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                      });
                    }, icon: const Icon(Icons.copy))
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Row(
                  children: [
                    const Text(
                      "Ngân hàng thụ hưởng : Mbbank",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "VPBank")).then((_){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                      });
                    }, icon: const Icon(Icons.copy))
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Row(
                  children: [
                    const Text(
                      "Số tài khoản : 8895.8895.99999",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {
                      Clipboard.setData(const ClipboardData(text: "01254665")).then((_){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                      });
                    }, icon: const Icon(Icons.copy))
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Lưu ý: sau khi chuyển khoản chụp bill và liên hệ hotline: 0523.858.858 để được kích hoạt tài khoản",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Tài khoản sẽ được kích hoạt 30 ngày, sau 30 ngày bạn phải nạp tiền lại để sử dụng đầy đủ chức năng của phần mềm để đạt được hiệu quả chạy ship cao nhất",
                  style: TextStyle(
                      fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    width: MediaQuery.of(context).size.width - 80,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/ic_zalo.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Liên hệ Zalo',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _openApp('https://zalo.me/0523858858');
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ));
  }

  _openApp(String url) async {
    if (Platform.isAndroid) {
      launch(url);
    } else {
      await LaunchApp.openApp(
        androidPackageName: 'net.pulsesecure.pulsesecure',
        iosUrlScheme: 'pulsesecure://',
        appStoreLink: url,
        // openStore: false
      );
    }
  }
}
