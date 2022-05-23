import 'package:demo_button/firebase/auth.dart';
import 'package:demo_button/screens/login.dart';
import 'package:demo_button/screens/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final databaseReference = FirebaseDatabase.instance.reference();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  void setDataFirstTime(String cmd, String cmdValue) {
    databaseReference
        .child("${_emailController.text}")
        .update({cmd: cmdValue}).asStream();
    print("$cmd  $cmdValue");
  }

  createCollection() {
    setDataFirstTime("esp_status", "false");
    setDataFirstTime("temperature", "0");
    setDataFirstTime("heart_rate", "0");
    setDataFirstTime("SPO2", "0");
    setDataFirstTime("pulse_pattern", "0");
    setDataFirstTime("prediction", "0");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff040F23),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png'),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Sign Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Full Name',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hoverColor: Colors.grey,
                    hintText: 'Enter your Full Name',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(0.5)),
                  ),
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email';
                    } else if (isEmail(value) == false) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your Email Address',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5))),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: !isPasswordVisible,
                  controller: _passwordController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(0.5)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please re-enter your password';
                    } else if (_passwordController.text != value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: !isConfirmPasswordVisible,
                  controller: _confirmPasswordController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your Password',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(0.5)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      child: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (!_formKey.currentState.validate()) {
                      return null;
                    } else {
                      createAccount(_nameController.text, _emailController.text,
                              _passwordController.text)
                          .then((value) {
                        if (value == null) {
                          FirebaseAuth.instance.currentUser
                              .sendEmailVerification();
                          Fluttertoast.showToast(
                              msg:
                                  'Verification Email Sent to ${_emailController.text}',
                              backgroundColor: Color(0xff040F23),
                              textColor: Colors.white);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerificationScreen()));
                          createCollection();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff040F23)),
                    child: Center(
                        child: Text('Sign Up',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));
                        },
                        child: Text(
                          'Sign in instead',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
