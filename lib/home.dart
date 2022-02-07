import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_iot/utils/strap.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'package:wakelock/wakelock.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  double strapValue1 = 0.0;
  double strapValue2 = 0.0;
  double lowValue = 3;
  double highValue = 3;
  String wifiNetwork = "loadcellesp";
  bool isChannelConnected = false;
  bool isWifiConnected = false;
  bool isMobileInternet = false;
  bool ledstatus = false;
  Socket channel;
  String reciever = "";
  bool isPluginEnabled = false;

  Future<void> sendcmd(String cmd) async {
    try {
      channel.write(cmd);
    } catch (_) {
      print("error on sending msg.");
    }
  }

  Future<bool> connectionValue;
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   connectionValue = test();
  // }

  bool connection = false;
  bool insideLoop = false;
  bool testSuccess = false;
  String status = "";
  Future<bool> test() async {
    bool connection = await WiFiForIoTPlugin.isEnabled();
    return connection;
  }

  Future<void> check() async {
    print("check called");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Better to Turn off mobile internet \n and keep turn ON WiFi only");
      setState(() {
        isMobileInternet = true;
      });
    } else
      setState(() {
        isMobileInternet = false;
      });
    bool a = await WiFiForIoTPlugin.isEnabled();
    String c = wifiNetwork  ;
    String b = await WiFiForIoTPlugin.getSSID();
    if (!a) {
      await WiFiForIoTPlugin.setEnabled(true);
    } else if (b != c) {
      connectWifi();
    }
    if (isMobileInternet) {
      setState(() {
        status = "Better to Turn off mobile internet \n and keep turn ON WiFi only";
      });
    } else if ((b != c)) {
      setState(() {
        status = "reconnecting wifi";
      });
    } else {
      setState(() {
        status = "Connected";
      });
    }
  }

  Future<void> connectWifi() async {
    isWifiConnected = await WiFiForIoTPlugin.connect(wifiNetwork,
        security: NetworkSecurity.WPA, password: "123456789");
    if (isWifiConnected == false) {
      connectWifi();
    } else {
      print("iswificonnected = $isWifiConnected , channel called");
      channelconnect();
    }
  }

  Future<void> channelconnect() async {
    try {
      // ignore: close_sinks
      Socket _channel = await Socket.connect('192.168.43.230', 80);
      setState(() {
        channel = _channel;
      });
      channel.listen(
        (message) {
          String s = String.fromCharCodes(message);
          print("prinitng recieving object");
          print(s);
          setState(() {
            reciever = s;
          });
          setState(() {
            if (reciever.contains("strap1"))
              try {
                strapValue1 = double.parse(reciever.replaceAll("strap1", ""));
              } catch (_) {
                print("error in double value.");
              }
            print(strapValue1);
          });
          setState(() {
            if (reciever.contains("strap2"))
              try {
                strapValue2 = double.parse(reciever.replaceAll("strap2", ""));
              } catch (_) {
                print("error in double value.");
              }
            print(strapValue2);
          });
        },
        // onDone: () {
        //   print("Web socket is closed");
        //     // connectWifi();
        // },
        onError: (error) {
          print("err " + error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Timer timer;
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    connectWifi();
    // channelconnect();
    timer = Timer.periodic(Duration(seconds: 8), (Timer t) => check());
    ledstatus = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                channelconnect();
              },
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ], title: Text("Weight Strap"), backgroundColor: Colors.black),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Strap(strapValue1, channel, 1),
                  Strap(strapValue2, channel, 2),
                ],
              ),
              Text(
                'Logs : $reciever',
              ),
              Text(
                '$status',
              ),
              ElevatedButton(onPressed: () => check(), child: Text("Update"))
            ],
          ),
        ));
  }
}
