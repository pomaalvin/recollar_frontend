import 'package:flutter/material.dart';

class ButtonPrimaryCPNT extends StatelessWidget {
  VoidCallback  onPressed;
  Size size;
  Color colorBg;
  Color colorText;
  String text;
  double elevation;
 ButtonPrimaryCPNT({Key? key,required this.onPressed,required this.size,required this.colorBg,required this.colorText,required this.text,required this.elevation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      elevation: elevation,
          height: size.height,
          minWidth:size.width,
          onPressed: onPressed,
          color: colorBg,
          child: Center(
            child: Text(text,style: TextStyle(color: colorText,fontSize: 18),),
          ),

        );
  }
}

