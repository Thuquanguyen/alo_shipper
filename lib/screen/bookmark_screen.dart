import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/items/item_ship.dart';
import 'package:shipper/model/ship_model.dart';
import 'package:shipper/model/user_model.dart';
import 'package:shipper/network/repository.dart';
import 'package:shipper/widget/message_handler.dart';

import '../constance.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  List<Shipper> listData = [];
  bool isActive = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isShowLoading = false;

  void initUser() async {
    User user = await getData();
    LoginController().user = user;
    print('isActive KAKAK = $isActive');
    isActive = LoginController().user?.status == 'ACTIVE' ? true : false;
    setState(() {});
    handleAction();
  }

  void handleAction() {
    Repository().getNotes().then((value) {
      listData = value.data ?? [];
      listData = listData.reversed.toList();
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    MessageHandler().register(KEY_ADD_NOTE, handleNotification);
    if (LoginController().user == null) {
      initUser();
    } else {
      handleAction();
      isActive = LoginController().user?.status == 'ACTIVE' ? true : false;
    }

    super.initState();
  }

  void handleNotification(){
    print('CALL BACK MESSAGE');
    handleAction();
  }

  @override
  void dispose() {
    MessageHandler().unregister(KEY_ADD_NOTE);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromRGBO(237, 241, 246, 1),
          appBar: AppBar(
            title: const Text(
              'Danh sách đơn đã lưu',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            color: Colors.transparent,
            child: listData.isEmpty
                ? const Center(
                    child: Text('Không có dữ liệu!'),
                  )
                : SmartRefresher(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ItemShip(
                            shipModel: listData[index].attributes,
                            isActive: isActive,
                            isHiddenWarning: true,
                            isNote: true,
                            onTap: () {},
                            callApi: (int id, shipModel) {
                              setState(() {
                                isShowLoading = true;
                              });
                              Repository()
                                  .createNote('$id', false)
                                  .then((value) {
                                isShowLoading = false;
                                final index = listData.indexWhere((element) =>
                                    element.attributes == shipModel);
                                if (index < listData.length) {
                                  listData.removeAt(index);
                                  setState(() {});
                                }
                              });
                            });
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
                  ),
          ),
        ),
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

  void _onRefresh() async {
    handleAction();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
