import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
// import 'package:vin_decoder/vin_decoder.dart';

void main() {
  runApp(VxState(
    store: MyStore(),
    child: MyApp(),
  ));
}

// Store
class MyStore extends VxStore {
  String vin = '';
}

final TextEditingController vinTextController = TextEditingController();

// Mutations
class VINInput extends VxMutation<MyStore> {
  @override
  perform() => store?.vin = vinTextController.text;
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final VxStore store = MyStore();

  void dispose() {
    vinTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vinTextController.addListener(() {
      VINInput();
    });
    VxState.watch(context, on: [VINInput]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mechanic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: 'Mechanic'.text.make()),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              'Scan or input your VIN'.text.make(),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                  child: TextField(
                    controller: vinTextController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your VIN',
                    ),
                  )),
              vinTextController.text.text.make(),
            ],
          ),
        ),
      ),
    );
  }
}
