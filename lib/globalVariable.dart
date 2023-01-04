// show progress indicator
// show progress dialog
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void showProgressDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

// hide progress dialog
void hideProgressDialog(context) {
  Navigator.pop(context);
}


Position? currentPosition;
User? currentUser = FirebaseAuth.instance.currentUser;
StreamSubscription<Position>? homeTabPositionStream;
DatabaseReference? rideRef;
StreamSubscription<Position>? ridePositionStream;
String? uuid;
String serverKey =
    'key=AAAAzfB5cac:APA91bG6phSeKptccUpMHhsY7L3H9xUPOIaHeE5zIE0MbF-bDw4Mg-ZKOhtU9g4ZYagdS5Rj-ELFLE3jjOUS2vuStfFFigKX5qm_4awSwmJ4ufX0M9JUsp9Uyxb5vFy6bM71Gw5GCp0A';
