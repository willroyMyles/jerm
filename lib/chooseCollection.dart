import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jerm/network/executor.dart';
import 'package:jerm/ticketOptionsView.dart';

import 'models/codeParent.model.dart';

class ChooseCollection extends StatelessWidget {
  ChooseCollection({Key? key}) : super(key: key);
  TextEditingController tc = TextEditingController();
  final controller = Get.put(ChooseCollectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Collection"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.dialog(AlertDialog(
            alignment: Alignment.center,
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: tc,
              ),
              TextButton(
                  onPressed: () async {
                    await Ex.generateCollection(tc.text);
                    Get.close(1);
                    controller.setUp();
                  },
                  child: const Text("generate"))
            ]),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<ChooseCollectionController>(
        builder: (_) {
          return Container(
            child: ListView.builder(
              itemCount: _.list?.length ?? 0,
              itemBuilder: (context, index) {
                var item = _.list!.elementAt(index)!;
                return InkWell(
                  onTap: () {
                    Get.to(() => TicketOperations(codes: item));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: Colors.black.withOpacity(.2))),
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text(item.title),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ChooseCollectionController extends GetxController {
  List<CodeParent?>? list;
  bool canSave = false;

  setUp() async {
    var ans = await Ex.getCollections();
    list = ans;
    refresh();
  }

  changeNum(int amount, String pid, String id) {
    var parent = list?.firstWhere((element) => element!.id == pid);
    var pidx = list?.indexOf(parent);
    var child = parent?.codes.firstWhere((element) => element.id == id);

    if (child != null) {
      var childIdx = parent?.codes.indexOf(child);
      list?[pidx!]!.codes.remove(child);
      child.maxRedeemTimes = amount;
      child.isEditing = canSave = true;

      list?[pidx!]!.codes.remove(child);
      list?[pidx!]!.codes.insert(childIdx!, child);
      refresh();
    }
  }

  saveList(String pid) {
    var parent = list?.firstWhere((element) => element!.id == pid);
    if (parent != null) {
      var pidx = list?.indexOf(parent);

      Ex.saveList(parent);
      canSave = false;
      setUp();
      Get.back();
      // Get.to(() => TicketOperations(codes: parent));
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setUp();
  }

  void updateShared(String pid, String id) async {
    var parent = list?.firstWhere((element) => element!.id == pid);
    var pidx = list?.indexOf(parent);
    var child = parent?.codes.firstWhere((element) => element.id == id);

    if (child != null) {
      await Ex.updateShared(child, parent!.title);
      Get.back();
      setUp();
    }
  }
}
