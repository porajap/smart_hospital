import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_hospital/src/bloc/auth/auth_bloc.dart';
import 'package:smart_hospital/src/model/home/queue_detail_model.dart';
import 'package:smart_hospital/src/model/home/queue_model.dart';
import 'package:smart_hospital/src/model/home/queue_of_front_model.dart';
import 'package:smart_hospital/src/pages/home/scan_page.dart';
import 'package:smart_hospital/src/pages/login/login_page.dart';
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

  final GeolocatorPlatform _geoLocator = GeolocatorPlatform.instance;

  double destination = 0;
  double roomLatitude = 18.77021350974426;
  double roomLongitude = 98.97541530144976;

  bool isConfirm = false;
  Barcode? qrCodeResult;
  Timer? timer;

  @override
  void initState() {
    queueToday();
    setupFCM();
    // _getCurrentPosition();
    super.initState();
  }

  void setupFCM() async{
    PushNotificationService pushNotificationService = PushNotificationService();

    await pushNotificationService.setupFlutterNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      pushNotificationService.showFlutterNotification(message);
      if(message.notification != null){
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
      appBar: MyAppBar(
        context: context,
        title: "Smart Hospital",
        action: AppBarAction(
          onPressed: () {
            MyDialog.dialogConfirm(
              context: context,
              callback: () {
                timer?.cancel();
                context.read<AuthBloc>().add(AuthEventLoggedOut());
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
            child: queueData.data == null
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
        onPressed: openScanPage,
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

  Widget buildUserData() {
    var _userData = queueData.data?.userDetail;
    var _queueData = queueData.data;

    String _hnCode = _userData?.hnCode ?? "";
    String _fName = _userData?.fNameTh ?? "";
    String _lName = _userData?.lNameTh ?? "";
    String _fullName = '$_fName $_lName';

    String _date = _queueData?.dateAt ?? "";
    String _time = _queueData?.timeAt ?? "";

    String _userType = "ทั่วไป";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("หมายเลข HN", style: TextStyle(fontSize: 12)),
                  Text("$_hnCode",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("วันที่/เวลา ที่มาถึง รพ.", style: TextStyle(fontSize: 12)),
                  Text("$_date $_time",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ชื่อ - นามสกุล", style: TextStyle(fontSize: 12)),
                  Text("$_fullName",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("ประเภทผู้ป่วย", style: TextStyle(fontSize: 12)),
                  Text("$_userType",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetail() {
    var _isConfirm = queueData.data?.isConfirm;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildUserData(),
                  Divider(),
                  buildQueueDetail(),
                ],
              ),
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
                    child: Text("ยันยันรับคิว"),
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

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        children: [
          Column(
            children: [
              Column(
                children: [
                  Text(
                    "หมายเลขคิวของคุุณ",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    "(${_roomName})",
                    style: TextStyle(
                      color: AppColor.textPrimaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                "${_queueNo}",
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 36,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "คิวของห้อง",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$_queueOfRoom",
                      style: TextStyle(
                        color: AppColor.primaryColor.withOpacity(0.5),
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  color: AppColor.grayColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "คิวก่อนหน้า",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$_queueOfFront",
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
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> queueToday() async {
    queueData = await queueService.queueOfUserToday();

    if (queueData.data != null && (queueData.data?.userDetail?.hnCode == "" || queueData.data?.userDetail?.hnCode == null)) {
      dialogEditHnCode();
    }

    setState(() {});

    bool _error = queueData.error ?? false;
    if (!_error) {
      timerQueueOfFront();
    }
  }

  Future<void> queueDetailCurrent() async {
    queueData = await queueService.queueOfUserToday();
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

  Future<void> _getCurrentPosition() async {
    BotToast.showLoading();

    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geoLocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    logger.i(position);

    destination = await _geoLocator.distanceBetween(
      position.latitude,
      position.longitude,
      roomLatitude,
      roomLongitude,
    );

    logger.w("Destination ${destination.round()} M"); //to m.

    List<Placemark> startPlaceMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark startPlace = startPlaceMarks[0];
    logger.w(startPlace);

    List<Placemark> endPlaceMarks = await placemarkFromCoordinates(roomLatitude, roomLongitude);
    Placemark endPlace = endPlaceMarks[0];
    logger.w(endPlace);

    BotToast.closeAllLoading();

    // if (destination.round() > 20) {
    //   MyDialog.dialogCustom(
    //     context: context,
    //     title: "ผิดพลาด",
    //     msg: 'คุณอยู่ห่างจากห้องมากกว่า 20 ม. ไม่สามารถยืนยันคิวได้',
    //     callback: () {},
    //   );
    // }
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
                    "กรุณากรอก HN",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 10),
                  InputHeight(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกเลข HN หรือติดต่อเจ้าหน้าที่";
                        }

                        return null;
                      },
                      controller: _hnController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        hintText: "กรุณากรอกเลข HN หรือติดต่อเจ้าหน้าที่",
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

                              BotToast.showText(text: "บันทึกสำเร็จ");
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
