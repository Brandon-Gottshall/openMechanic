import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:http/http.dart' as http;
import 'package:vin_decoder/vin_decoder.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:mechanic/services/auth.service.dart';
import 'package:mechanic/config/env.dart';

void main() {
  runApp(VxState(
    store: MyStore(),
    child: MyApp(),
  ));
  registerServices();
}

// Store
class MyStore extends VxStore {
  String vin = '';
  String year = '';
  String make = '';
  String model = '';
}

final getIt = GetIt.instance;

void registerServices() {
  getIt.registerSingleton<AuthService>(AuthService());
}

final TextEditingController textController = TextEditingController();
final listener = textController.addListener(() {
  VINInput();
});

// Mutations
class VINInput extends VxMutation<MyStore> {
  @override
  Future<void> perform() async {
    store?.vin = textController.text;
    if (textController.text.length > 4) {
      var path = 'https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/' +
          textController.text +
          '?format=json';
      final response = await http.get(Uri.parse(path));
      Map<String, dynamic> responseBody = json.decode(response.body);
      // print(response.body);
      String? model = responseBody['Results'][8]['Value'] ?? '';
      store?.year = responseBody['Results'][9]['Value'] ?? '';
      store?.make = responseBody['Results'][6]['Value'] ?? '';
      store?.model = model ?? 'No Model Found';
    }
  }
}

class RandomVIN extends VxMutation<MyStore> {
  @override
  perform() {
    String generatedVin = VINGenerator().generate();
    textController.text = generatedVin;
    store?.vin = generatedVin;
    VINInput().perform();
  }
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

  void dispose() {
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [VINInput]);
    MyStore store = VxState.store;
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
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your VIN',
                    ),
                  )),
              TextButton(
                  child: 'Get VIN'.text.make(),
                  onPressed: () {
                    VINInput();
                  }),
              TextButton(
                  child: 'Random VIN'.text.make(),
                  onPressed: () {
                    RandomVIN();
                  }),
              textController.text.text.make(),
              'Year: ${store.year}'.text.make(),
              'Make: ${store.make}'.text.make(),
              'Model: ${store.model}'.text.make(),
              'Test Key: ${Secret.test_key}'.text.make(),
            ],
          ),
        ),
      ),
    );
  }
}
