// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iot/home.dart';
// import 'package:screen/screen.dart';
import 'package:wifi_iot/wifi_iot.dart';

class FlutterWifiIoT extends StatefulWidget {
  @override
  _FlutterWifiIoTState createState() => _FlutterWifiIoTState();
}

class _FlutterWifiIoTState extends State<FlutterWifiIoT> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }

  List<WifiNetwork> _htResultNetwork = [];
  bool _isEnabled = false;
  bool _isConnected = false;
  String ssid = "";
  @override
  initState() {
    WiFiForIoTPlugin.setEnabled(true);
    getWifis();

    super.initState();
    // Wakelock.enable(); 
    initPlatformState();
  }

  initPlatformState() async {
    // bool keptOn = await Screen.isKeptOn;
    // double brightness = await Screen.brightness;
    setState(() {
      // _isKeptOn = keptOn;
      // _brightness = brightness;
    });
  }

  getWifis() async {
    _isEnabled = await WiFiForIoTPlugin.isEnabled();
    _isConnected = await WiFiForIoTPlugin.isConnected();
    _htResultNetwork = await loadWifiList();
    setState(() {});
    if (_isConnected) {
      WiFiForIoTPlugin.getSSID().then((value) => setState(() {
            ssid = "hasa";
          }));
    }
  }

  Future<List<APClient>> getClientList(
      bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;
    try {
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } on PlatformException {
      htResultClient = List<APClient>();
    }

    return htResultClient;
  }

  Future<List<WifiNetwork>> loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = List<WifiNetwork>();
    }

    return htResultNetwork;
  }

  isRegisteredWifiNetwork(String ssid) {
    return ssid == this.ssid;
  }

  Widget getWidgets(context) {
    WiFiForIoTPlugin.isConnected().then((val) => setState(() {
          _isConnected = val;
        }));

    return SingleChildScrollView(
      child: Column(
        children: getButtonWidgetsForAndroid(context),
      ),
    );
  }

  List<Widget> getButtonWidgetsForAndroid(context) {
    List<Widget> htPrimaryWidgets = List();
    WiFiForIoTPlugin.isEnabled().then((val) => setState(() {
          _isEnabled = val;
        }));
    htPrimaryWidgets.addAll({
      SizedBox(height: 10),
      Text(
        'Wi-Fis Found',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      getList(context)
    });
    if (_isEnabled) {
      WiFiForIoTPlugin.isConnected().then((val) {
        if (val != null) {
          setState(() {
            _isConnected = val;
          });
        }
      });
    }

    return htPrimaryWidgets;
  }

  getList(contex) {
    return ListView.builder(
      itemBuilder: (builder, i) {
        var network = _htResultNetwork[i];
        var isConnctedWifi = false;
        if (_isConnected)
          isConnctedWifi = isRegisteredWifiNetwork(network.ssid);

        if (_htResultNetwork != null && _htResultNetwork.length > 0) {
          return Container(
            color: isConnctedWifi
                ? Colors.indigo.shade100
                : Colors.indigo.shade100,
            child: ListTile(
                title:
                    Text(network.ssid, style: TextStyle(color: Colors.black)),
                trailing: !isConnctedWifi
                    ? OutlineButton(
                        onPressed: () {
                          Navigator.of(contex)
                              .push(MaterialPageRoute(builder: (_) => Home()));
                        },
                        child: Text('Connect',
                            style: TextStyle(color: Colors.black)),
                      )
                    : SizedBox()),
          );
        } else
          return Center(
            child: Text('No wifi found'),
          );
      },
      itemCount: _htResultNetwork.length,
      shrinkWrap: true,
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument);
}
