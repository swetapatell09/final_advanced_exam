import 'package:final_advance_exam/screen/cart/view/cart_screen.dart';
import 'package:final_advance_exam/screen/home/view/home_screen.dart';
import 'package:final_advance_exam/screen/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String,WidgetBuilder> app_routes={
   "/":(context)=> const SplashScreen(),
  "home":(context)=> const HomeScreen(),
  "cart":(context)=> const CartScreen(),
};