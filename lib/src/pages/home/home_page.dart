import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_hospital/src/model/home/queue_detail_model.dart';
import 'package:smart_hospital/src/pages/login/login_page.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/date_time_format.dart';
import 'package:smart_hospital/src/utils/my_dialog.dart';
import 'package:smart_hospital/src/utils/my_widget.dart';

import '../../../main.dart';
import '../../utils/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }
}

class _HomePageState extends State<HomePage> {
  QueueDetail? _queueDetail;

  bool isLoading = false;

  final GeolocatorPlatform _geoLocator = GeolocatorPlatform.instance;

  double destination = 0;
  double roomLatitude = 18.764691;
  double roomLongitude = 98.937154;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: "Smart Hospital",
        action: AppBarAction(
          onPressed: () {
            MyDialog.dialogConfirm(
              context: context,
              callback: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName('/login'),
                );
              },
              title: "ออกจากระบบ",
              msg: 'คุณต้องการออกจากระบบใช่หรือไม่?',
            );
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: MyScreen(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: _queueDetail == null
                ? Center(
                    child: Text(
                      "สแกนคิวอาร์โค้ดเพื่อดูรายละเอียด",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )
                : buildDetail(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanQrCode,
        tooltip: "สแกนคิวอาร์โค้ด",
        child: Icon(Icons.qr_code_scanner_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColor.primaryColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.bookmark_add),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetail() => SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "ลำดับของคุุณคือ",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${_queueDetail!.queue}",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Column(
                        children: [
                          Text(
                            "ลำดับก่อนหน้า",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${_queueDetail!.queue! - 2}",
                            style: TextStyle(
                              color: AppColor.primaryColor.withOpacity(0.5),
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: _getCurrentPosition,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("ยืนยันลำดับ"),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Future<void> scanQrCode() async {
    BotToast.showLoading();

    await Future.delayed(Duration(seconds: 1));

    final _date = DateTime.now();
    final _time = TimeOfDay.now();

    if (_queueDetail != null) {
      _queueDetail = null;
      BotToast.closeAllLoading();
      setState(() {});
      return;
    }

    _queueDetail = QueueDetail(
      date: ConvertDateTimeFormat.convertDateFormat(date: _date),
      time: ConvertDateTimeFormat.convertTimeFormat(time: _time),
      queue: 20,
      prefix: 'นางสาว',
      fName: 'Lorem',
      lName: 'Ipsum',
      roomName: 'ห้องฉุกเฉิน',
    );

    BotToast.closeAllLoading();

    setState(() {});
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geoLocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    destination = await _geoLocator.distanceBetween(
      position.latitude,
      position.longitude,
      roomLatitude,
      roomLongitude,
    );

    logger.i(destination / 1000);

    if(destination > 20){
      MyDialog.dialogCustom(context: context, title: "ผิดพลาด", msg: 'คุณอยู่ห่างจากห้องมากกว่า 20 ม. ไม่สามารถยืนยันคิวได้');
    }

    setState(() {});
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geoLocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geoLocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }
}
