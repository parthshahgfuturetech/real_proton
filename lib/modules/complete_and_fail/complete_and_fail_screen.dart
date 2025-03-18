import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';

class CompleteAndFailScreen extends StatelessWidget {
  CompleteAndFailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        backgroundColor: completeAndFailController.isCompleteAndFail.value
            ? ColorUtils.indicaterColor1
            : ColorUtils.failColor,
        body: SafeArea(
          bottom: true,
          minimum: EdgeInsets.only(bottom: 20),
          child:  completeAndFailController.isCompleteAndFail.value
                ? buildComplete()
                : buildFailContainer(),
        ),
      ),
    );
  }

  Widget buildFailContainer() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/checkmark-2.png",
            height: 85,
            width: 85,
            fit: BoxFit.fill,
          ),
          buildTitleText("Oops!"),
          buildSubTitleText(
              "It Seems There Was a Problem Completing Your\nTransaction, Please Try Agian!"),
        ],
      ),
    );
  }

  Widget buildComplete() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageUtils.checkmark1,
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              buildTitleText("Congratulations!"),
              buildSubTitleText(
                  "Your Purchase Has Been Completed\nSuccessfully!"),
            ],
          ),
        ),
        Container(
          height: 30,
          width: double.infinity,
          alignment: Alignment.center,
          color: ColorUtils.completeGreenColor,
          child: Text(
            "Your Tokens Are Locked For 90 Days!",
            style: TextStyle(
              fontSize: 13,
              fontFamily: "Switzer",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(color: Colors.white),
          child: GestureDetector(
            onTap: () {
              completeAndFailController.isCompleteAndFail.value = false;
            },
            child: Center(
              child: Text(
                "View All Transactions",
                style: TextStyle(
                  color: ColorUtils.indicaterColor1,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSubTitleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: "Switzer",
      ),
    );
  }

  Widget buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 36,
        fontFamily: "Switzer",
      ),
    );
  }
}
