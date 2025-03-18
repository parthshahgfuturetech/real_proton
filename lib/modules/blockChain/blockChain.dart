import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_proton/modules/blockChain/blockChain_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Celo Token Info',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final BlockChainController blockChainController = Get.put(BlockChainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Celo Token Info")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text("Token Price: ${blockChainController.tokenPrice.value}", style: TextStyle(fontSize: 18))),
            Obx(() => Text("User Balance: ${blockChainController.userBalance.value}", style: TextStyle(fontSize: 18))),
            Obx(() => Text("Total Supply: ${blockChainController.totalSupply.value}", style: TextStyle(fontSize: 18))),
            Obx(() => Text("Identity Registry: ${blockChainController.identityRegistry.value}", style: TextStyle(fontSize: 18))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                blockChainController.fetchData();
              },
              child: Text("Refresh Data"),
            ),
          ],
        ),
      ),
    );
  }
}


