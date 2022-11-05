import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jerm/chooseCollection.dart';
import 'package:jerm/redeemTicket.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Get.to(() => RedeemCode());
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 3, color: Colors.black.withOpacity(.6))),
                child: const Text("Redeem Code"),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TextEditingController tc = TextEditingController();

          var ans = await Get.dialog(AlertDialog(
            alignment: Alignment.center,
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: tc,
              ),
              TextButton(
                  onPressed: () async {
                    var text = tc.text;

                    Get.back(result: text == "abc123.");
                  },
                  child: const Text("Submit PassPhrase"))
            ]),
          ));
          if (ans != null && ans) {
            Get.to(() => ChooseCollection());
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
