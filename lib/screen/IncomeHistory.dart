import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class IncomeHistory extends StatefulWidget {
  const IncomeHistory({super.key});

  @override
  State<IncomeHistory> createState() => _IncomeHistoryState();
}

class _IncomeHistoryState extends State<IncomeHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income History'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        child: const Text('Income History'),
      ),
    );
  }
}
