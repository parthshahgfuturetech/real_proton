import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/main.dart';
import 'package:real_proton/utils/colors.dart';
import 'package:real_proton/utils/images.dart';

import '../../utils/widgets.dart';

class CompleteAndFailScreen extends StatelessWidget {
  final Map<String, dynamic> responseJson;
CompleteAndFailScreen({required this.responseJson, Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
  print("Received responseJson==: $responseJson"); // Debugging line

  return Obx(
      ()=> Scaffold(
        body: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: 20),
          child:  completeAndFailController.isCompleteAndFail.value
                ? buildComplete()
                : buildComplete(),
        ),
      ),
    );
  }

  Widget buildFailContainer() {
    return Container(
      color: ColorUtils.failColor,
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
    String formattedDate = "N/A";

    int timestamp = responseJson['data']['updatedAt']; // Ensure it's an int

    if (timestamp > 0) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

                                   formattedDate =
          "${date.day} ${CustomWidgets.getMonthName(date.month)} ${date.year}, "
          "${CustomWidgets.formatHour(date.hour)}:${CustomWidgets.formatMinute(date.minute)} ${CustomWidgets.getPeriod(date.hour)}";

      print(formattedDate);
    } else {
      print("Invalid timestamp");
    }


    return Column(
      children: [
        Expanded(
          child: Container(
            color: ColorUtils.indicaterColor1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImageUtils.checkmark1,
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                buildTitleText("Payment Received!"),
                buildSubTitleText(
                    "Your transaction has been successfully completed.\nYour RP Tokens will be credited to your account after verification"),
              ],
            ),
          ),
        ),


        SizedBox(height: 20),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          buildTimelineItem(
            "Payment Received",
            "USDT has been Deducted from your wallet\nand Sent to Admin",
            true,false
          ),
          buildTimelineItem(
            "Submitted For Approval",
            "Waiting For Approval of Your Transaction",
            true,false
          ),
          buildTimelineItem(
            "Token Received",
            "Your RP Tokens Credited in Your Wallet",
            true,true
          ),
          SizedBox(height: 20),

          // Transaction Details
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorUtils.appbarBackgroundDark,

              border: Border.all(color: ColorUtils.loginButton, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTransactionDetail("Amount", "\$${responseJson['data']['txnAmount']}"),
                buildTransactionDetail("Expected RP Token", "${responseJson['data']['rpAmount']}"),
                buildTransactionIdSet("Transaction Id", "${responseJson['data']['paymentId']}"),
                buildTransactionDetail("Date & Time", formattedDate),
              ],
            ),
          ),
          SizedBox(height: 20),

          CustomWidgets.buildGetStartedButton(
            onPressed: () {
              Get.back();
            },
            text: 'Done',
           ),

        ],
      ),
    ),
        ],

    );
  }
  Widget buildTimelineItem(String title, String subtitle, bool isCompleted, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Circle with inner white dot
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green, // Outer green circle
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Inner white dot
                  ),
                ),
              ),
            ),

            if (!isLast)
              Align(
                alignment: Alignment.center, // Ensures proper alignment
                child: Container(
                  width: 4,
                  height: 55, // Adjust height to match spacing
                  color: Colors.green,
                ),
              ),
          ],
        ),
        SizedBox(width: 12), // Adjust spacing
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Switzer",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 0),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Switzer",
                  color: ColorUtils.forgotPasswordTextDark, // Adjusted color for description
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildTransactionDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: ColorUtils.forgotPasswordTextDark,fontWeight: FontWeight.w400, fontSize: 14,fontFamily: "Switzer")),
          Text(value, style: TextStyle(fontSize: 14,fontFamily: "Switzer", fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );

  }

  Widget buildTransactionIdSet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: ColorUtils.forgotPasswordTextDark,fontWeight: FontWeight.w400, fontSize: 14,fontFamily: "Switzer")),
          Text(CustomWidgets.formatAddress(value), style: TextStyle(fontSize: 14,fontFamily: "Switzer", fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
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
