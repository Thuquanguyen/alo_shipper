import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:shipper/constance.dart';
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/model/ship_model.dart';
import 'package:shipper/screen/payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemShip extends StatelessWidget {
  const ItemShip(
      {Key? key,
      this.shipModel,
      this.isActive = false,
      this.onTap,
      this.isNote = false,
      this.onDelete,
      this.callApi,
      this.isHiddenWarning = false})
      : super(key: key);

  final Attributes? shipModel;
  final bool? isActive;
  final Function? onTap;
  final bool? isHiddenWarning;
  final bool? isNote;
  final Function? onDelete;
  final Function? callApi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                shipModel?.username ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
              GestureDetector(
                onTap: () {
                  callApi?.call(shipModel?.id ?? 0, shipModel);
                },
                child: (isNote ?? false)
                    ? const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      )
                    : const Icon(
                        Icons.bookmark,
                        color: Colors.lightBlueAccent,
                      ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          if (isActive ?? false)
            Text(
              shipModel?.content ?? '',
              style:
                  const TextStyle(fontWeight: FontWeight.normal, height: 1.5),
            ),
          if (!(isActive ?? false))
            Text(
              checkPhoneNumber(shipModel?.content ?? ''),
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                child: Row(
                  children: const [
                    Icon(
                      Icons.phone_forwarded,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Gọi ngay')
                  ],
                ),
                onTap: () {
                  checkActive(context, 0,
                      phoneNumber: getPhoneNumber(shipModel?.content ?? ''));
                },
              )),
              Expanded(
                  child: GestureDetector(
                child: Row(
                  children: const [
                    Icon(
                      Icons.message,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Nhắn tin')
                  ],
                ),
                onTap: () {
                  checkActive(context, 1,
                      phoneNumber: getPhoneNumber(shipModel?.content ?? ''));
                },
              )),
              if (!(isHiddenWarning ?? false))
                Expanded(
                    child: GestureDetector(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cảnh báo')
                    ],
                  ),
                  onTap: () {
                    checkActive(context, 2,
                        phoneNumber: getPhoneNumber(shipModel?.content ?? ''),
                        shipModel: shipModel);
                  },
                )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          const SizedBox(
            height: 10,
          ),
          if (!(isHiddenWarning ?? false))
            Row(
              children: [
                Text(
                  'Cập nhật lúc ${shipModel?.readTimestamp() ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 8,
                ),
                // const Text('|'),
                // const SizedBox(
                //   width: 4,
                // ),
                // const Text('10 km'),
                // const SizedBox(
                //   width: 4,
                // ),
                // const Text('|'),
                // const SizedBox(
                //   width: 4,
                // ),
                // const Expanded(
                //   child: Text(
                //     'Ha Noi',
                //     softWrap: true,
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // )
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  void checkActive(BuildContext context, int index,
      {String? phoneNumber, Attributes? shipModel}) {
    if (LoginController().user?.status == 'ACTIVE') {
      if (index == 0) {
        _openApp('tel:$phoneNumber');
      } else if (index == 1) {
        _openApp('sms:$phoneNumber');
      } else {
        onTap?.call(shipModel);
      }
    } else {
      showDialog(context: context, builder: (_) => const PaymentScreen());
    }
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
