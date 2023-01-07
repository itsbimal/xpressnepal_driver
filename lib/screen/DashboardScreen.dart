import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xpressnepal/api/push_notification.dart';
import 'package:xpressnepal/globalVariable.dart';
import 'package:xpressnepal/widget/OfferDialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _currentIndex = 0;
  late GoogleMapController controller;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 30.4746,
  );
  final Completer<GoogleMapController> _controller = Completer();

  void getLocation() async {
    Position? currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  @override
  void initState() {
    getLocation();
    PushNotificationService.initialize(context);
    PushNotificationService.getToken();
    super.initState();
  }

  String? userId;
  final LatLng _currentLocation = const LatLng(0.0, 0.0);
  DatabaseReference? trigRequestRef;

  void _goOnline() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPosition = position;
      userId = currentUser!.uid;
      Geofire.initialize('driverAvailable');
      Geofire.setLocation(
          userId!, _currentLocation.latitude, _currentLocation.longitude);

      trigRequestRef = FirebaseDatabase.instance.ref('user/$userId/newRide');
      trigRequestRef!.set('waiting');
    } catch (e) {
      print('Errorx: $e');
    }
  }

  void _getLocatonLiveUpdates() {
    homeTabPositionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isAvailable) {
        Geofire.setLocation(userId!, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void goOffline() {
    Geofire.removeLocation(currentUser!.uid);
    homeTabPositionStream!.cancel();
    trigRequestRef!.onDisconnect();
    trigRequestRef!.remove();
    trigRequestRef = null;
  }

  // create offer on firebase
  

  bool isAvailable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Xpress Nepal',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: CupertinoSwitch(
                  value: isAvailable,
                  onChanged: (value) {
                    if (value) {
                      _goOnline();
                      getLocation();
                      _getLocatonLiveUpdates();
                      setState(() {
                        isAvailable = true;
                      });
                    } else {
                      goOffline();
                      setState(() {
                        isAvailable = false;
                      });
                    }
                  }),
            )
          ],
        ),
        body: StreamBuilder(
            stream:
                FirebaseDatabase.instance.ref().child('riderequest').onValue,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                    animating: true,
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                Map<dynamic, dynamic> delivery_val =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                // Iterate through the ride history objects and build a list
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: delivery_val.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var delivery = delivery_val.values.elementAt(index);
                      String documentKey = delivery_val.keys.elementAt(index);
                      return Card(
                        child: ListTile(
                            title: Text(
                              'ORDER: $documentKey',
                            ),
                            leading: const Icon(Icons.notifications_active),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Store ${delivery['pickup_address']}'),
                                Text(
                                    'Store ${delivery['destination_address']}'),

                                // BUTTONS
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigator.pop(context);
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
                                        'Reject',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // show the dialog
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Offerialog(
                                                fares: delivery['fares'],
                                                documentKey: documentKey,
                                              );
                                            });
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
                                        'Accept',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text('रू ${delivery['fares']}',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const Text('5KM RIDE'),
                              ],
                            )),
                      );
                    });
              } else {
                return const Center(
                  child: Text('Offer found!'),
                );
              }
            })
        // GoogleMap(
        //   mapType: MapType.normal,
        //   myLocationEnabled: true,
        //   initialCameraPosition: _kGooglePlex,
        //   onMapCreated: (GoogleMapController controller) {
        //     _controller.complete(controller);
        //   },
        // ),
        );
  }
}
