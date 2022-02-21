import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shipper/controller/login_controller.dart';
import 'package:shipper/items/item_profile.dart';
import 'package:shipper/model/profile_model.dart';
import 'package:shipper/model/user_model.dart';
import 'package:shipper/network/repository.dart';

import '../constance.dart';
import 'login_screen.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  _HomeAdminScreenState createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  List<DataProfile> _listProfile = [];

  final searchController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late int pageIndex = 1;
  bool isLoading = false;

  void initUser()async{
    User user = await getData();
    LoginController().user = user;
    handleAction();
  }

  void handleAction(){
    Repository().getListUser(pageNumber: pageIndex).then((value) {
      _listProfile = value.data ?? [];
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if(LoginController().user == null){
      initUser();
    }else{
      handleAction();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _buildHeader(),
            _buildBoxSearch(),
            Expanded(
              child: SmartRefresher(
                child: _listProfile.isEmpty
                    ? const Center(
                      child: Text('Không có dữ liệu!'),
                    )
                    : ListView.builder(
                        itemBuilder: (content, index) =>
                            ItemProfile(profileModel: _listProfile[index]),
                        itemCount: _listProfile.length,
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
      ),
    );
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      pageIndex += 1;
      Repository().getListUser(pageNumber: pageIndex).then((value) {
        if(value.data?.isNotEmpty ?? false){
          _listProfile.addAll(value.data ?? []);
        }else{
          pageIndex -= 1;
        }
        print('pageIndex = $pageIndex');
        setState(() {});
      });
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    Repository().getListUser(pageNumber: 1).then((value) {
      _listProfile = value.data ?? [];
      setState(() {});
    });
    _refreshController.refreshCompleted();
  }

  Widget _buildHeader(){
    return Container(
      margin: const EdgeInsets.only(left: 15,right: 15),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
          ),
          GestureDetector(
            child: Row(
              children: const [
                Text(
                  'Đăng xuất',
                  style: TextStyle(fontWeight: FontWeight.w500),
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
            onTap: () async{
              await clearStatusLogin();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                  ModalRoute.withName('/') // Replace this with your root screen's route name (usually '/')
              );
            },
          )
        ],
      ),
    );
  }
  Widget _buildBoxSearch() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: searchController,
            onChanged: (text) {
              print('TEXT CHANGE = $text');
              Repository().searchProfile(text).then((value) {
                _listProfile = value.data ?? [];
                setState(() {});
              });
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
                hintText: "UserName or Full Name",
                hintStyle: TextStyle(color: Colors.grey[400])),
          )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black.withOpacity(0.5),
              )),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 5),
    );
  }
}
