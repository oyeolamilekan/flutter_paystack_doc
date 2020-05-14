import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_paystack_doc/utils/inputFormaters.dart';
import 'package:flutter_paystack_doc/utils/utils.dart';
import 'package:flutter_paystack_doc/widgets/button.dart';

class CheckoutMethodUI extends StatefulWidget {
  @override
  _CheckoutMethodUIState createState() => _CheckoutMethodUIState();
}

class _CheckoutMethodUIState extends State<CheckoutMethodUI> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumber = TextEditingController();
  final _expDate = TextEditingController();
  final _cvv = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    PaystackPlugin.initialize(
        publicKey: "pk_test");
    super.initState();
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: hexToColor("#41aa5e"),
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PaymentCard _getCardFromUI() {
      List spiltDates = _expDate.text.split("/");
      return PaymentCard(
        number: getCleanedNumber(_cardNumber.text),
        cvc: _cvv.text,
        expiryMonth: int.parse(spiltDates[0]),
        expiryYear: int.parse(spiltDates[1]),
      );
    }

    String _getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
      return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
    }

    _chargeCard(String reference, int amount) async {
      var charge = Charge()
        ..amount = amount
        ..email = "johnsonoe34@gmail.com"
        ..reference = reference
        ..card = _getCardFromUI();

      await PaystackPlugin.chargeCard(context,
          charge: charge,
          beforeValidate: (transaction) => handleBeforeValidate(transaction),
          onSuccess: (transaction) => handleOnSuccess(transaction),
          onError: (error, transaction) => handleOnError(error, transaction));
    }

    Widget cardNumber = TextFormField(
      obscureText: false,
      decoration: InputDecoration(
        hintText: "Card Number",
        border: InputBorder.none,
      ),
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      controller: _cardNumber,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(19),
        new CardNumberInputFormatter()
      ],
      validator: validateCardNumWithLuhnAlgorithm,
    );

    Widget expDate = TextFormField(
      obscureText: false,
      decoration: InputDecoration(
        hintText: 'MM/YY',
        border: InputBorder.none,
      ),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(4),
        new CardMonthInputFormatter()
      ],
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      controller: _expDate,
      validator: validateDate,
    );

    Widget cvv = TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          hintText: "CVV",
          border: InputBorder.none,
        ),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          new LengthLimitingTextInputFormatter(4),
        ],
        cursorColor: Colors.black,
        keyboardType: TextInputType.emailAddress,
        controller: _cvv,
        validator: validateCVV);

    Widget buildForms() {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: cardNumber,
              decoration: BoxDecoration(
                  color: hexToColor("#F5F6FA"),
                  borderRadius: BorderRadius.circular(3)),
            ),
            SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: expDate,
                    decoration: BoxDecoration(
                        color: hexToColor("#F5F6FA"),
                        borderRadius: BorderRadius.circular(3))),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: cvv,
                    decoration: BoxDecoration(
                        color: hexToColor("#F5F6FA"),
                        borderRadius: BorderRadius.circular(3))),
              ),
            ]),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Payment for: PayStack testing.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                buildForms(),
                SizedBox(
                  height: 10,
                ),
                Button(
                  child: Text(loading ? "Charging" : "Charge Card.",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onClick: () async {
                    if (_formKey.currentState.validate() && !loading) {
                      setState(() {
                        loading = true;
                      });
                      var reference = _getReference();
                      await _chargeCard(reference, 90000 * 100);
                    }
                  },
                )
              ],
            )),
      ),
    );
  }

  handleBeforeValidate(Transaction transaction) {
    print(transaction.message);
  }

  handleOnSuccess(Transaction transaction) {
    loading = false;
    setState(() => {});
    print("success");
    _showDialog();
  }

  handleOnError(Object error, Transaction transaction) {
    loading = false;
    setState(() => {});
    print("error");
    _showErrorDialog();
  }
}
