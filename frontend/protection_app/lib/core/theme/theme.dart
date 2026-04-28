import 'package:first_video/core/theme/AppPallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
    static _borderinputdecoration([Color color = AppPallete.borderColor]) =>OutlineInputBorder(
        borderSide: BorderSide(
          color:color ,
          width: 3,
        
        ), 
        borderRadius: BorderRadius.circular(10) ,
        
        
      );
  static final darkthemode = ThemeData.dark().copyWith(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppPallete.gradient2,
      // unselectedItemColor: AppPallete.,
      backgroundColor: AppPallete.backgroundColor,
    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor ,
    inputDecorationTheme: InputDecorationTheme(
      border: _borderinputdecoration(),
      contentPadding: EdgeInsets.all(27) , 
      focusedBorder: _borderinputdecoration(AppPallete.gradient2),
      enabledBorder:  _borderinputdecoration(),
      errorBorder: _borderinputdecoration(AppPallete.errorColor), 

    

    ) , 
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.transparentColor ,
      elevation: 0
    ) , 
    chipTheme: ChipThemeData(

      color: MaterialStateProperty.all(AppPallete.backgroundColor), 
      side: BorderSide.none ,
      

      
    )
  );


}

