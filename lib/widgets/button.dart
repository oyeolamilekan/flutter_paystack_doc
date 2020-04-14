import 'package:flutter/material.dart';
import 'package:flutter_paystack_doc/utils/hexToColor.dart';

class Button extends StatelessWidget {
  final Widget child;
  final Function onClick;

  Button({this.child, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4), color: Colors.black12),
      child: Material(
        color: hexToColor("#41aa5e"),
        child: InkWell(
            onTap: onClick,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
