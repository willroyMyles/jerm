import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jerm/models/codeParent.model.dart';
import 'package:nanoid/async.dart';

class Executor {
  var db = FirebaseFirestore.instance;

  final collection = "jerm Coll";

  generateCollection(String name, {int amount = 50}) async {
    var pid = await nanoid(8);
    var cid = await nanoid(8);
    var path = name;

    var doc = CodeParent(
        id: pid,
        title: name,
        codes: List.generate(amount, (index) {
          return Codes(
              id: "${_customAlphabet(urlAlphabet, 5).toUpperCase()}-$index",
              parentId: pid,
              path: path);
        }));
    db.collection(collection).doc(path).set(doc.toMap());
  }

  String _customAlphabet(String alphabet, int size) {
    final len = alphabet.length;
    var random = Random();
    String id = '';
    while (0 < size--) {
      id += alphabet[random.nextInt(len)];
    }
    return id;
  }

  saveList(CodeParent p) async {
    db.collection(collection).doc(p.title).set(p.toMap());
  }

  updateShared(Codes c, String doc) async {
    db.collection(collection).doc(doc).update({
      "codes": FieldValue.arrayRemove([c.toMap()])
    });
    c.shared = true;
    db.collection(collection).doc(doc).update({
      "codes": FieldValue.arrayUnion([c.toMap()])
    });
  }

  updateRedeemed(Codes c, String doc) async {
    db.collection(collection).doc(doc).update({
      "codes": FieldValue.arrayRemove([c.toMap()])
    });
    c.timesRedeemed += 1;
    c.isCompleted = c.maxRedeemTimes == c.timesRedeemed;
    db.collection(collection).doc(doc).update({
      "codes": FieldValue.arrayUnion([c.toMap()])
    });
  }

  redeemCode(String path, String id) async {
    //get code
    try {
      var codes = await db
          .collection(collection)
          .withConverter(
              fromFirestore: fromFb, toFirestore: (a, b) => toFb(a, b))
          .doc(path)
          .get();
      if (!codes.exists) throw "code does not exsist";
      var code = codes.data()!.codes.firstWhere((element) => element.id == id);
      if (code != null) {
        if (code.maxRedeemTimes <= code.timesRedeemed) {
          throw "Max Redemption reached ${code.timesRedeemed}/${code.maxRedeemTimes}";
        }

        updateRedeemed(code, path);
        return Future.value(code);
      } else {
        throw "Could not find ticket";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CodeParent?>> getCollections() async {
    var ans = await db
        .collection(collection)
        .withConverter(fromFirestore: fromFb, toFirestore: (a, b) => toFb(a, b))
        .limit(10)
        .get();

    return ans.docs.map((e) => e.data()).toList();
  }

  var fromFb = (snapshot, options) {
    if (snapshot.exists) {
      return CodeParent.fromMap(snapshot.data()!);
    }
    return null;
  };

  var toFb = (data, options) {
    return data?.toMap();
  };
}

Executor _executor = Executor();
Executor get Ex => _executor;
