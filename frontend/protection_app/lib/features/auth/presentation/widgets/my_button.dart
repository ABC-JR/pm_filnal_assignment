import 'package:first_video/core/theme/AppPallete.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

   MyButton({super.key , this.text = "Sign up" , required this.onTap }) ;
  final String text ;
  final VoidCallback? onTap ;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPallete.gradient1, AppPallete.gradient2],
          begin: Alignment.bottomLeft , 
          end: Alignment.topRight
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      
      child: ElevatedButton(
        onPressed: onTap ,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: AppPallete.transparentColor,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
