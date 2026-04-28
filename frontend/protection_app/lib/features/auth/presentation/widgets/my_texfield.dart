import 'package:flutter/material.dart';

class MyTexfield extends StatelessWidget {
 
  MyTexfield({super.key , required this.hinttext , required this.textcontroller , 
    this.isobcured  = false
  }) ;
   final hinttext;
   final textcontroller;

  final isobcured ;



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hinttext , 
      ),
      validator: (value) {
        if(value!.isEmpty){
          return "Please enter your $hinttext" ;
        }
        return null;
      },
      controller: textcontroller ,
      obscureText: isobcured ,
      
    );
  }
}