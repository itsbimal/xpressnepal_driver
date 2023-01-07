import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Offerialog extends StatefulWidget {
  Offerialog({super.key, required this.fares, required this.documentKey});

  String fares;
  String documentKey;

  @override
  State<Offerialog> createState() => _OfferialogState();
}

class _OfferialogState extends State<Offerialog> {
  late int fares;
  // INCRESE FARES
  void increaseFares() {
    setState(() {
      fares = fares + 10;
    });
    createOffer(widget.documentKey);
  }

  void decreaseFares() {
    setState(() {
      fares = fares - 10;
    });
    createOffer(widget.documentKey);
  }

  void createOffer(String documentKey) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference rideRef =
        FirebaseDatabase.instance.ref('riderequest/$documentKey/offer');

    final json = {'offerPrice': fares, 'offerBy': 'Anonymous'};
    rideRef.child(userId).set(json);
  }

  void updateOffer(String documentKey) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference rideRef =
        FirebaseDatabase.instance.ref('riderequest/$documentKey/offer');

    // if user already offered then update the offer

    if (rideRef.child(userId) != null) {
      final json = {'offerPrice': fares, 'offerBy': 'Anonymous'};
      rideRef.child(userId).update(json);
    } else {
      createOffer(documentKey);
    }
  }

  @override
  void initState() {
    fares = int.parse(widget.fares);
    createOffer(widget.documentKey);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [
          // image
          Image.asset(
            'assets/images/offer.png',
            width: 100,
            height: 100,
            alignment: Alignment.center,
          ),
          const Text(
            'YOU OFFERED',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'रू $fares',
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          // INCREASE AND DECREASE BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  decreaseFares();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  '- 10',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  increaseFares();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
                child: const Text(
                  '+ 10',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            // BUTTONS
          ),

          // cancel and confirm buttons
          SizedBox(
            // wifdth has to be 100% of the parent
            width: 130,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                'Cancel Offer',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
