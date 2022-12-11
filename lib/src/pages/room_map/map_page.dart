import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_hospital/src/model/location/room_location_model.dart';
import 'package:smart_hospital/src/services/queue_service.dart';
import 'package:smart_hospital/src/utils/app_bar.dart';

import '../my_app.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key, required this.roomId}) : super(key: key);

  var roomId;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  RoomLocationModel roomLocationModel = RoomLocationModel();
  String roomName = "";

  final GeolocatorPlatform _geoLocator = GeolocatorPlatform.instance;

  double destination = 0;

  @override
  void initState() {
    getRoomLocation();
    super.initState();
  }

  Future<void> getRoomLocation() async {
    final _queueService = QueueService();

    roomLocationModel = await _queueService.getLocationOfRoom(roomId: widget.roomId);
    roomName = roomLocationModel.data?.name ?? "";

    _getCurrentPosition();

    if (mounted) {
      setState(() {});
    }
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

    var roomLatitude = roomLocationModel.data?.latitude ?? 0;
    var roomLongitude = roomLocationModel.data?.longitude ?? 0;

    destination = await _geoLocator.distanceBetween(
      position.latitude,
      position.longitude,
      roomLatitude as double,
      roomLongitude as double,
    );

    logger.w("Destination ${destination.round()} M"); //to m.

    List<Placemark> startPlaceMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark startPlace = startPlaceMarks[0];
    logger.w(startPlace);

    List<Placemark> endPlaceMarks = await placemarkFromCoordinates(roomLatitude, roomLongitude);
    Placemark endPlace = endPlaceMarks[0];
    logger.w(endPlace);

    BotToast.closeAllLoading();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "$roomName", context: context, showBack: true),
      body: Container(
        child: Center(
          child: roomLocationModel.data == null ? CircularProgressIndicator() : SizedBox(),
        ),
      ),
    );
  }
}
