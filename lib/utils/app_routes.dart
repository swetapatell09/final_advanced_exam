
import 'package:flutter/material.dart';

import '../screen/cart/view/cart_screen.dart';
import '../screen/home/view/home_screen.dart';
import '../screen/splash/view/splash_screen.dart';

Map<String,WidgetBuilder> app_routes={
   "/":(context)=> const SplashScreen(),
  "home":(context)=> const HomeScreen(),
  "cart":(context)=> const CartScreen(),
};