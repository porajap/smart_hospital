import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_hospital/src/bloc/auth/auth_bloc.dart';
import 'package:smart_hospital/src/model/home/queue_detail_model.dart';
import 'package:smart_hospital/src/model/home/queue_model.dart';
import 'package:smart_hospital/src/model/home/queue_of_front_model.dart';
import 'package:smart_hospital/src/pages/home/scan_page.dart';
import 'package:smart_hospital/src/pages/login/login_page.dart';
import 'package:smart_hospital/src/pages/room_map/map_page.dart';
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/queue_service.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/date_time_format.dart';
import 'package:smart_hospital/src/utils/my_dialog.dart';
import 'package:smart_hospital/src/utils/my_widget.dart';

import '../../../main.dart';
import '../../services/push_notification_service.dart';
import '../../utils/app_bar.dart';
import '../../utils/constants.dart';
import '../my_app.dart';
import 'components/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final queueService = QueueService();

  QueueModel queueData = QueueModel();
  QueueOfFrontModel queueOfFrontData = QueueOfFrontModel();

  bool isLoading = false;


  bool isConfirm = false;
  Barcode? qrCodeResult;
  Timer? timer;

  @override
  void initState() {
    queueToday();
    setupFCM();
    super.initState();
  }

  void setupFCM() async {
    PushNotificationService pushNotificationService = PushNotificationService();

    await pushNotificationService.setupFlutterNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      pushNotificationService.showFlutterNotification(message);
      if (message.notification != null) {
        queueToday();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    logger.i('timer active: ${timer?.isActive}');
    super.dispose();
  }

  Future openScanPage() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanPage())).then((value) {
      if (value != null) {
        scanQrCode(queueNo: value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: Container(
          // padding: EdgeInsets.symmetric(vertical: 10),
          child: HomeAppBar(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            queueData.data == null
                ? SizedBox()
                : Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(70),
                        )),
                  ),
            MyScreen(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: queueData.data == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("${Constants.imageUrl}/home_qr.png", width: 180),
                            SizedBox(height: 20),
                            Text("?????????????????????????????????", style: Theme.of(context).textTheme.headline1),
                            SizedBox(height: 5),
                            Text("????????????????????????????????????????????????????????????????????????????????????????????????"),
                          ],
                        ),
                      )
                    : buildDetail(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: queueData.data != null
          ? SizedBox()
          : BottomAppBar(
              elevation: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton.icon(
                  onPressed: openScanPage,
                  label: Text("?????????????????????????????????????????????"),
                  icon: Icon(Icons.qr_code_scanner_rounded),
                ),
              ),
            ),
    );
  }

  Widget buildUserData() {
    var _userData = queueData.data?.userDetail;
    var _queueData = queueData.data;
    var _queueNo = queueData.data?.queueNo;

    String _hnCode = _userData?.hnCode ?? "";
    String _fName = _userData?.fNameTh ?? "";
    String _lName = _userData?.lNameTh ?? "";
    String _fullName = '$_fName $_lName';

    String _date = _queueData?.dateAt ?? "";
    String _time = _queueData?.timeAt ?? "";

    String _userType = "??????????????????";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dataDetail(title: "???????????? - ?????????????????????", detail: _fullName),
              Container(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              dataDetail(title: "?????????????????????????????????", detail: "$_queueNo"),
              Container(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              dataDetail(title: "????????????????????? HN", detail: "$_hnCode", detailColor: AppColor.primaryColor),
              Container(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              dataDetail(title: "???????????????????????????????????????", detail: "$_userType"),
              Container(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              dataDetail(title: "???????????????????????????????????????????????????????????????", detail: "$_date $_time"),
              Container(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
              Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(
                          roomId: queueData.data?.roomId,
                        ),
                      ),
                    );
                  },
                  child: Text("??????????????????????????????????????????"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dataDetail({required String title, required String detail, Color? detailColor}) {
    detailColor = detailColor ?? AppColor.textPrimaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title"),
        Text(
          "$detail",
          style: TextStyle(color: detailColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDetail() {
    var _isConfirm = queueData.data?.isConfirm;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildQueueDetail(),
                buildUserData(),
              ],
            ),
            SizedBox(height: 5),
            Visibility(
              visible: _isConfirm == 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: confirmQueue,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("????????????????????????????????????"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQueueDetail() {
    var _queueData = queueData.data;
    var _queueDetail = queueData.data?.queueDetail;
    var _queueFront = queueOfFrontData.data?.queueOfFront ?? _queueDetail?.queueOfFront ?? 0;

    String _queueNo = _queueData?.queueNo ?? "";
    String _roomName = _queueData?.roomName ?? "";

    String _queueOfRoom = _queueDetail?.queueOfRoom != null ? '${_queueDetail?.queueOfRoom as int}' : '-';
    String _queueOfFront = '$_queueFront';

    return Stack(
      children: [
        Image.asset(
          "${Constants.imageUrl}/home_q.png",
          width: double.maxFinite,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text(
                "${_roomName}",
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.successColor),
                      child: Column(
                        children: [
                          Text(
                            "$_queueOfRoom",
                            style: TextStyle(color: AppColor.whiteColor, fontSize: 32),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "???????????????????????????",
                            style: TextStyle(color: AppColor.whiteColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.successColor),
                      child: Column(
                        children: [
                          Text(
                            "$_queueOfFront",
                            style: TextStyle(color: AppColor.whiteColor, fontSize: 32),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "???????????????????????????????????????",
                            style: TextStyle(color: AppColor.whiteColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> queueToday() async {
    queueData = await queueService.queueOfUserToday();

    if (queueData.data != null &&
        (queueData.data?.userDetail?.hnCode == "" || queueData.data?.userDetail?.hnCode == null)) {
      dialogEditHnCode();
    }

    logger.w(queueData.toJson());

    setState(() {});

    bool _error = queueData.error ?? false;
    if (!_error) {
      timerQueueOfFront();
    }
  }

  Future<void> queueDetailCurrent() async {
    queueData = await queueService.queueOfUserToday();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> timerQueueOfFront() async {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => queueDetailCurrent());
  }

  Future<void> scanQrCode({required String queueNo}) async {
    BotToast.showLoading();

    queueData = await queueService.scanQr(queueNo: queueNo.trim());
    setState(() {});

    bool _error = queueData.error ?? false;

    if (_error) {
      timerQueueOfFront();
      return;
    }
    queueToday();
    BotToast.closeAllLoading();
  }

  Future<void> confirmQueue() async {
    BotToast.showLoading();

    int _queueId = queueData.data?.id as int;
    int _roomId = queueData.data?.roomId as int;
    String _queueNo = queueData.data?.queueNo ?? "";

    queueData = await queueService.confirmQueue(queueId: _queueId, queueNo: _queueNo, roomId: _roomId);
    bool _error = queueData.error ?? false;
    if (!_error) {
      queueToday();
    }
    setState(() {
      BotToast.closeAllLoading();
    });
  }

  Future<void> queueOfFront() async {
    String _queueNo = queueData.data?.queueNo ?? "";
    var _queueOfRoom = queueData.data?.queueDetail?.queueOfRoom ?? 0;

    queueOfFrontData = await queueService.queueOfFront(queueNo: _queueNo, queueOfRoom: _queueOfRoom as int);

    setState(() {});
  }


  var _hnFormKey = GlobalKey<FormState>();
  TextEditingController _hnController = TextEditingController(text: "");

  void dialogEditHnCode() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          content: Container(
            child: Form(
              key: _hnFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "??????????????????????????? HN",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 10),
                  InputHeight(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "???????????????????????????????????? HN ???????????????????????????????????????????????????????????????";
                        }

                        return null;
                      },
                      controller: _hnController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        hintText: "???????????????????????????????????? HN ???????????????????????????????????????????????????????????????",
                        errorStyle: TextStyle(height: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => {
                              _hnController.text = "",
                            },
                            style: ElevatedButton.styleFrom(primary: AppColor.grayColor, elevation: 0),
                            child: Text(
                              "${Constants.textClear}",
                              style: TextStyle(color: AppColor.textPrimaryColor.withOpacity(0.7)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              var _result = await queueService.updateHnCode(hnCode: _hnController.text.trim());

                              queueToday();

                              Navigator.pop(context);

                              BotToast.showText(text: "????????????????????????????????????");
                            },
                            style: ElevatedButton.styleFrom(elevation: 0),
                            child: Text("${Constants.textConfirm}"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
