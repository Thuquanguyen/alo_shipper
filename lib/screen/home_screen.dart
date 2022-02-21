import 'dart:async';
import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/items/item_ship.dart';
import 'package:shipper/model/ship_model.dart';
import 'package:shipper/model/user_model.dart';
import 'package:shipper/network/repository.dart';
import 'package:shipper/screen/login_screen.dart';
import 'package:shipper/screen/payment_screen.dart';
import 'package:shipper/widget/message_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  List<Shipper> listData = [];
  bool isActive = false;
  bool isShowLoading = false;

  Animation<double>? _animation;
  AnimationController? _animationController;

  void configAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  void initUser() async {
    User user = await getData();
    LoginController().user = user;
    setState(() {});
    handleAction();
  }

  void handleAction() {
    Repository().getData(true).then((value) {
      listData = value.data ?? [];
      setState(() {});
    });

    Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      if (listData.isNotEmpty) {
        Repository().getData(false, minId: listData[0].id).then((value) {
          for (Shipper item in value.data ?? []) {
            listData.insert(0, item);
          }
          setState(() {});
        });
      } else {}
    });

    isActive = LoginController().user?.status == 'ACTIVE' ? true : false;
  }

  @override
  void initState() {
    configAnimation();
    print('USER NAME = ${LoginController().user?.username}');
    if (LoginController().user == null) {
      initUser();
    } else {
      handleAction();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: const Color.fromRGBO(237, 241, 246, 1),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/images/ic_avatar.jpg')),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: const Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ]),
                              height: 65,
                              width: 65,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Xin Chào,',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        LoginController().user?.fullName ?? '',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    LoginController().user?.username ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        LoginController().user?.status ==
                                            'ACTIVE'
                                            ? Icons.verified
                                            : Icons.warning,
                                        color: LoginController()
                                            .user
                                            ?.status ==
                                            'ACTIVE'
                                            ? Colors.blueAccent
                                            : Colors.red,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        LoginController().user?.status ==
                                            'ACTIVE'
                                            ? 'Đã kích hoạt'
                                            : 'Chưa kích hoạt',
                                        style: TextStyle(
                                            color: LoginController()
                                                .user
                                                ?.status ==
                                                'ACTIVE'
                                                ? Colors.blueAccent
                                                : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Row(
                                children: const [
                                  Text(
                                    'Đăng xuất',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 17,
                                  )
                                ],
                              ),
                              onTap: () async {
                                await clearStatusLogin();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const LoginScreen()),
                                    ModalRoute.withName(
                                        '/') // Replace this with your root screen's route name (usually '/')
                                    );
                              },
                            )
                          ],
                        ),
                      ),
                      if (listData.isNotEmpty)
                        Expanded(
                          child: SmartRefresher(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ItemShip(
                                  shipModel: listData[index].attributes,
                                  isActive: isActive,
                                  onTap: (Attributes? shipModel) {
                                    setState(() {
                                      isShowLoading = true;
                                    });
                                    Repository()
                                        .warningUser(
                                            shipModel?.fbUserPostId ?? '')
                                        .then((value) {
                                      isShowLoading = false;
                                      if (value == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Đã gửi cảnh báo!"),
                                        ));
                                      }
                                      setState(() {});
                                    });
                                  },
                                  callApi: (int id, shipModel) {
                                    setState(() {
                                      isShowLoading = true;
                                    });
                                    Repository()
                                        .createNote('$id', true)
                                        .then((value) {
                                      isShowLoading = false;
                                      if (value == true) {
                                        MessageHandler().notify(KEY_ADD_NOTE);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Đơn đã lưu"),
                                        ));
                                      }
                                      setState(() {});
                                    });
                                  },
                                );
                              },
                              itemCount: listData.length,
                            ),
                            enablePullDown: true,
                            enablePullUp: true,
                            header: const WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (context, mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text("pull up load");
                                } else if (mode == LoadStatus.loading) {
                                  body = const CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = const Text("Load Failed!Click retry!");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = const Text("release to load more");
                                } else {
                                  body = const Text("No more Data");
                                }
                                return SizedBox(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                          ),
                        )
                    ],
                  ),
                  if (listData.isEmpty)
                    const Center(
                      child: Text('Không có dữ liệu!'),
                    )
                ],
              ),
            ),
            floatingActionButton: FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: "Nạp Tiền",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.monetization_on_rounded,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    showDialog(
                        context: context,
                        builder: (_) => const PaymentScreen());
                    _animationController?.reverse();
                  },
                ),
                // Floating action menu item
                Bubble(
                  title: "Hotline",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.phone_forwarded,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _openApp('tel:0523858858');
                    _animationController?.reverse();
                  },
                ),
                Bubble(
                  title: "Messenger",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.message,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _openApp('sms:0523858858');
                    _animationController?.reverse();
                  },
                ),
                //Floating action menu item
                Bubble(
                  title: "Zalo",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.widgets_outlined,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _openApp('https://zalo.me/0523858858');
                    _animationController?.reverse();
                  },
                ),
              ],

              // animation controller
              animation: _animation!,

              // On pressed change animation state
              onPress: () => (_animationController?.isCompleted)!
                  ? _animationController?.reverse()
                  : _animationController?.forward(),

              // Floating Action button Icon color
              iconColor: Colors.blue,

              // Flaoting Action button Icon
              iconData: Icons.apps_sharp,
              backGroundColor: Colors.white,
            )),
        if (isShowLoading)
          Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
            color: Colors.black.withOpacity(0.3),
          )
      ],
    );
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
