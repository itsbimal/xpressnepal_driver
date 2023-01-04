import 'package:flutter/material.dart';

class CollectPayment extends StatelessWidget {
  const CollectPayment(
      {super.key, required this.paymentMethod, required this.fares});

  final String paymentMethod;
  final int fares;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
          height: 350,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Collect Payment",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const Divider(
                      color: Colors.black,
                    ),
                    Image.asset(
                      'assets/images/cash.png',
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'NPR.$fares',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        "Make sure you have the exact amount of money before you click the button below.",
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Button
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        // style height and width
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/navbar');
                        },
                        child: const Text('RECEIVED'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
