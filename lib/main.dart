import 'package:flutter/material.dart';
import 'package:flutter_paystack_doc/index.dart';
import 'package:flutter_paystack_doc/pages/CheckoutMethodBank.dart';
import 'package:flutter_paystack_doc/pages/CheckoutMethodCard.dart';
import 'package:flutter_paystack_doc/pages/CheckoutMethodSelectable.dart';
import 'package:flutter_paystack_doc/pages/CheckoutMethodUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter paystack demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/checkOutMethodCard": (_) => CheckoutMethodCard(),
        "/checkOutMethodSelectedable": (_) => CheckoutMethodSelectable(),
        "/checkOutMethodBank": (_) => CheckoutMethodBank(),
        "/checkOutMethodUI": (_) => CheckoutMethodUI(),
      },
      home: Index(),
    );
  }
}
