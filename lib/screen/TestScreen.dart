import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xpressnepal/model/trip_details.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key,required this.tripDetails});
  final TripDetails tripDetails;


  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}