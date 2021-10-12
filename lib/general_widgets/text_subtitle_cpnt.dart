import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextSubtitleCPNT extends StatelessWidget {
  VoidCallback  ?onPressed;
  Color colorText;
  String text;
  FontWeight weight;
  TextSubtitleCPNT({Key? key,this.onPressed,required this.colorText,required this.text,required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Text(text,style: TextStyle(color: colorText,fontSize: 17,fontWeight: weight,),overflow: TextOverflow.ellipsis,maxLines: 2,),

    );
  }
}

