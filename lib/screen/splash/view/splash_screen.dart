import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () =>
        Navigator.pushReplacementNamed(context, "home"));}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/shopping-online.png",height: 150,width: 150,),
            const SizedBox(height: 10,),
            const Text("Shopping App",
                style: TextStyle(fontSize: 30, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
