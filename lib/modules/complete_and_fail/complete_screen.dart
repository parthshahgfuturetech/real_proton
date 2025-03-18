import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:real_proton/utils/colors.dart';

class CompleteScreen extends StatelessWidget {
  final String name;
  const CompleteScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.indicaterColor1,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    "assets/images/complete-1.png",
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRect(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Hi $name, Your Profile Has Been Successfully Created!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
