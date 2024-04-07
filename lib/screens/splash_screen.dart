import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:milcko/screens/getstarted_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late SpringSimulation _simulation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
    );
    _simulation = SpringSimulation(
      SpringDescription(
        mass: 0.5, 
        stiffness: 100, 
        damping: 10,
      ),
      0,//initial positon
      300,//target position
      0,//initial velocity
    );
    _controller.animateWith(_simulation);

    _controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      // Animation has completed, navigate to another screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedScreen()),
      );
    }
  });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context,Widget? child) {
            return Transform.translate(
              offset: Offset(4,_controller.value-300),
              child: Center(
                child: Image.asset('lib/images/logo.png',width: 150,height: 150,)
                ),
            );
        },),
    );
  }
}