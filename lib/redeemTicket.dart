import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jerm/network/executor.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RedeemCode extends StatelessWidget {
  RedeemCode({Key? key}) : super(key: key);
  final controller = Get.put(RedeemCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.onCodeScanned(code)
          controller.tryRedemption(
              controller.pathTC.text, controller.idTC.text);
        },
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        title: const Text("redeem code"),
        bottom: PreferredSize(
          preferredSize: Size(Get.width, 100),
          child: Container(
            padding: const EdgeInsets.all(10),
            // color: Colors.white.withOpacity(.1),
            child: Column(children: [
              Row(
                children: [
                  const Text("path :"),
                  Expanded(
                      child: TextField(
                    controller: controller.pathTC,
                  ))
                ],
              ),
              Row(
                children: [
                  const Text("id :"),
                  Expanded(
                      child: TextField(
                    controller: controller.idTC,
                  ))
                ],
              ),
            ]),
          ),
        ),
      ),
      body: GetBuilder<RedeemCodeController>(
        builder: (_) {
          return Stack(children: [
            Container(
              child: MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) async {
                    if (barcode.rawValue == null) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      await controller.onCodeScanned(barcode);
                    }
                  }),
            ),
            AnimatedPositioned(
              bottom: controller.redemptionString.isNotEmpty ? 0 : -280,
              duration: const Duration(milliseconds: 1400),
              child: InkWell(
                onTap: () {
                  controller.updateBottomBar();
                },
                child: AnimatedContainer(
                  width: Get.width,
                  height: 280,
                  color: controller.redemptionColor,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 1400),
                  child: Text(
                    controller.redemptionString,
                    textScaleFactor: 2.5,
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}

class RedeemCodeController extends GetxController {
  Color redemptionColor = Colors.transparent;
  String redemptionString = "";

  TextEditingController pathTC = TextEditingController();
  TextEditingController idTC = TextEditingController();
  onCodeScanned(Barcode code) async {
    var body = json.decode(code.rawValue!);
    var path = body['path'];
    var id = body['id'];
    print("$path , $id");

    await tryRedemption(path, id);
  }

  tryRedemption(String path, String id) async {
    try {
      var ans = await Ex.redeemCode(path, id);
      redemptionColor = Colors.green;
      redemptionString = "Code Redeemed";
    } catch (e) {
      redemptionColor = Colors.red;
      redemptionString = "Could not redeemed code\n${e.toString()}";
    }

    refresh();
  }

  void updateBottomBar() {
    redemptionColor = Colors.transparent;
    redemptionString = "";
    refresh();
  }
}
