import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:xpressnepal/globalVariable.dart';
import 'package:xpressnepal/model/trip_details.dart';
import 'package:xpressnepal/screen/NewDelivery.dart';

import '../provider/app_data.dart';

class PushNotificationService {
  static Future<String?> initialize(context) async {
    print("Notification service started");
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotificationService.getRideID(message, context);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: message.notification!.title,
                body: message.notification!.body));
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('error in push notification service $e');
    }
    return "";
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message $message');
  }

  static void getToken() async {
    String? userId = currentUser!.uid;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token;
    await firebaseMessaging.getToken().then((value) => token = value);
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.ref().child('user/$userId');
    tokenRef.update({'token': token});
    print('token is $token');
    firebaseMessaging.subscribeToTopic('alldrivers');
    firebaseMessaging.subscribeToTopic('allusers');
  }

  static getRideID(message, context) {
    String rideID = '';
    rideID = message.data['ride_id'];
    fetchRideInfo(rideID, context);
  }

  static fetchRideInfo(String rideID, context) async {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return const CupertinoActivityIndicator(
    //       radius: 20,
    //       color: Colors.white,
    //     );
    //   },
    // );
    print(rideID);

    final rideRef = FirebaseDatabase.instance.ref();
    final snapshot = await rideRef.child('riderequest/$rideID').get();
    // Navigator.pop(context);
    if (snapshot.exists) {
      try {
        Object? values = snapshot.value;
        Map<dynamic, dynamic> map = values as Map<dynamic, dynamic>;
        print(map);
        print('here 1');
        double pickupLat = map['location']['latitude'];
        print('here 2');

        double pickupLng = map['location']['longitude'];
        print('here 3');

        // latLng
        LatLng pickupLatLng = LatLng(pickupLat, pickupLng);
        String pickupAddress = map['pickup_address'];
        print('here 4');

        // destination
        double destinationLat = map['destination']['latitude'];
        print('here 5');

        double destinationLng = map['destination']['longitude'];
        print('here 6');

        String destinationAddress = map['destination_address'];
        print('here 7');

        String paymentMethod = map['payment_method'];
        print('here 8');

        String riderName = map['rider_name'];
        print('here 9');

        TripDetails tripDetails = TripDetails();
        tripDetails.rideID = rideID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;
        print('here 10');
        Provider.of<AppData>(context, listen: false)
            .updateDriverPickUpLocation(pickupLatLng);
        print('here 11');
        print(tripDetails.pickupAddress);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewDelivery(
                tripDetails: tripDetails,
              ),
            ));
      } catch (e) {
        print('here 12');

        print(e);
      }
    } else {
      print('here snapshot is not exist');
    }
  }
}
