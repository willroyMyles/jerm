import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jerm/models/codeParent.model.dart';
import 'package:jerm/shareService.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'chooseCollection.dart';

class TicketOperations extends StatelessWidget {
  final CodeParent codes;
  const TicketOperations({Key? key, required this.codes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseCollectionController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ticker Operations"),
          ),
          floatingActionButton: IgnorePointer(
            ignoring: !_.canSave,
            child: FloatingActionButton(
              onPressed: () {
                _.saveList(codes.id);
              },
              elevation: _.canSave ? 10 : 0,
              backgroundColor: _.canSave ? Colors.primaries[5] : Colors.grey,
              child: _.canSave
                  ? const Icon(Icons.save)
                  : const Icon(Icons.disabled_by_default),
            ),
          ),
          body: Container(
              child: ListView.builder(
            itemCount: codes.codes.length,
            itemBuilder: (context, index) {
              var item = codes.codes.elementAt(index);
              return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  decoration: BoxDecoration(
                      color: item.shared
                          ? Colors.lightBlue.shade100.withOpacity(.5)
                          : item.isCompleted
                              ? Colors.green.withOpacity(.3)
                              : Colors.transparent,
                      border: Border.all(
                          width: 2, color: Colors.black.withOpacity(.2))),
                  child: Wrap(
                    children: [
                      _buildBracket("max redeems", item.maxRedeemTimes),
                      _buildBracket("completed", item.isCompleted),
                      _buildBracket("times redeems", item.timesRedeemed),
                      _buildBracket("shared", item.shared),
                      _buildBracket("id", item.id),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                var count =
                                    (item.maxRedeemTimes + 1).clamp(1, 10);
                                Get.find<ChooseCollectionController>()
                                    .changeNum(count, codes.id, item.id);
                              },
                              child: const Text("incriment")),
                          TextButton(
                              onPressed: () {
                                var count =
                                    (item.maxRedeemTimes - 1).clamp(1, 10);
                                Get.find<ChooseCollectionController>()
                                    .changeNum(count, codes.id, item.id);
                              },
                              child: const Text("decriment")),
                          if (!item.shared)
                            TextButton(
                                onPressed: () async {
                                  await Get.dialog(AlertDialog(
                                    alignment: Alignment.center,
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            // height: 300,
                                            child: QrImage(
                                              data: item.toJson(),
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.center,
                                              child: Text(item.id)),
                                          TextButton(
                                              onPressed: () async {
                                                var data = await toQrImageData(
                                                    item.toJson());

                                                shareS.shareImage(
                                                    data, item.id);
                                                Get.find<
                                                        ChooseCollectionController>()
                                                    .updateShared(
                                                        codes.id, item.id);
                                              },
                                              child: const Text("Share"))
                                        ]),
                                  ));
                                  // .changeNum(count, codes.id, item.id);
                                },
                                child: const Text("Share")),
                          // if (item.isEditing)
                          //   TextButton(
                          //       onPressed: () {}, child: const Text("save")),
                        ],
                      )
                    ],
                  ));
            },
          )),
        );
      },
    );
  }

  Future<Uint8List> toQrImageData(String s) async {
    final image = await QrPainter(
            data: s,
            version: QrVersions.auto,
            color: Colors.blue.shade300,
            gapless: true,
            emptyColor: Colors.white)
        .toImageData(400);

    return image!.buffer.asUint8List();
  }

  _buildBracket(String s, dynamic v) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black.withOpacity(.1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(s), Text(": $v")],
      ),
    );
  }
}
