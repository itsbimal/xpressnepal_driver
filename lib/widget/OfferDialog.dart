import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:xpressnepal/api/push_notification.dart';
import 'package:xpressnepal/model/trip_details.dart';

class Offerialog extends StatefulWidget {
  Offerialog({super.key, required this.fares, required this.documentKey});

  String fares;
  String documentKey;

  @override
  State<Offerialog> createState() => _OfferialogState();
}

class _OfferialogState extends State<Offerialog> {
  String status = '';
  late int fares;

  String? driverID;
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

  StreamSubscription<DatabaseEvent>? rideSubscription;

  String? rider_status;
  final tripDetails = TripDetails();

  void createOffer(String documentKey) {
    String firstName = '';
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference usrRef =
        FirebaseDatabase.instance.ref('user/$userId/firstName');
    try {
      usrRef.once().then((DatabaseEvent snapshot) {
        DatabaseReference rideRef =
            FirebaseDatabase.instance.ref('riderequest/$documentKey/offer');

        final json = {
          'offerPrice': fares,
          'offerBy': snapshot.snapshot.value,
          'offerByID': userId
        };

        rideRef.child(userId).set(json);
      });
    } catch (e) {
      print("xxl error $e");
    }

    DatabaseReference newRequestRef =
        FirebaseDatabase.instance.ref().child('riderequest/$documentKey');

    rideSubscription = newRequestRef.onValue.listen((event) async {
      print("xxl listeninggg");
      if (event.snapshot.value == null) {
        return;
      }
      Object? values = event.snapshot.value;
      Map<dynamic, dynamic> map = values as Map<dynamic, dynamic>;
      status = map['status'].toString();
      driverID = map['driverID'].toString();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (status == 'accepted' && driverID == currentUser!.uid) {
        Navigator.pop(context);
        PushNotificationService.fetchRideInfo(documentKey, context);
      }
    });
  }

  void updateOffer(String documentKey) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference rideRef =
        FirebaseDatabase.instance.ref('riderequest/$documentKey/offer');
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
