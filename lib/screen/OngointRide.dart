import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OngoingRide extends StatefulWidget {
  const OngoingRide({super.key});

  @override
  State<OngoingRide> createState() => _OngoingRideState();
}

class _OngoingRideState extends State<OngoingRide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Ride'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        child: const Text('Ongoing Ride'),
      ),
    );
  }
}