import 'package:flutter/material.dart';
import 'package:flutter_iot/utils/wifiList.dart';
import 'package:wakelock/wakelock.dart';


void main()  {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,  home: FlutterWifiIoT()));
Wakelock.enable(); 
}
