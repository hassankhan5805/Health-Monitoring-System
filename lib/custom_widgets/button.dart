import 'package:flutter/material.dart';

Widget CustomButton({@required void Function() func, @required String label}) {
  return GestureDetector(
    onTap: () {
      func();
    },
    child: Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
          color: Color(0xff333333),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(4, 4)),
            BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(-4, -4)),
          ]),
      child: Center(
        child: Text(
          "$label",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ),
  );
}
