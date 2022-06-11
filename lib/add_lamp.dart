import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class AddLmap extends StatefulWidget {
  const AddLmap({Key? key}) : super(key: key);

  @override
  State<AddLmap> createState() => _AddLmapState();
}

class _AddLmapState extends State<AddLmap> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController wifiSSID = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    channelconnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Module', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff040F23),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(left: 20, right: 20, bottom: kToolbarHeight - 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset('assets/logo.png'),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Module',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SSID',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your SSID';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Enter Wifi SSID',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.withOpacity(0.5))),
                    keyboardType: TextInputType.emailAddress,
                    controller: wifiSSID,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter wifi password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Wifi Password',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return null;
                    } else {
                      write("ssid");
                      write("${wifiSSID.text}");
                      write("pass");
                      write("${passwordController.text}");

                      // Navigator.push(
                          // context,
                          // MaterialPageRoute(
                              // builder: (context) => MyHomePage()));
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff040F23)),
                    child: Center(
                        child: Text('Add Module',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Socket? channel;
  String reciever = "";

  Future<void> channelconnect() async {
    try {
      channel = await Socket.connect('192.168.43.230', 1669);
      channel!.listen(
        (message) {
          reciever = String.fromCharCodes(message);
          print(reciever);
        },
        onError: (error) {
          print("error in listening" + error.toString());
          // channelconnect();
        },
      );
    } catch (_) {
      print("error on connecting to socket.");
      channelconnect();
    }
  }

  write(String msg) {
    channel!.write(msg);
  }
}
