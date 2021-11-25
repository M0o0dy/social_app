
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/styles/colors.dart';
final ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(

    selectedItemColor: defaultColor,
    type: BottomNavigationBarType.fixed,
    elevation: 50,

  ),
  appBarTheme: AppBarTheme(

    titleSpacing: 20,
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,

    ),
    titleTextStyle: TextStyle(

        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black
    ),
    backwardsCompatibility: false,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
    ),
  ),
  textTheme: TextTheme(

    bodyText1: TextStyle(

      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  fontFamily: 'janna',

);

final ThemeData darkTheme = ThemeData(
  primarySwatch:defaultColor,

  scaffoldBackgroundColor: HexColor('353b37'),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor('353b37'),
    unselectedItemColor: Colors.grey,
    selectedItemColor: defaultColor,
    type: BottomNavigationBarType.fixed,
    elevation: 50,
  ),
  appBarTheme: AppBarTheme(
    titleSpacing: 20,
    color: HexColor('353b37'),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white
    ),
    backwardsCompatibility: false,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('353b37'),
      statusBarIconBrightness:  Brightness.light,
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),

  ),
    fontFamily: 'janna',
);

