import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpressnepal/model/Auction.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  List<Auction> auctions = [];
  @override
  void initState() {
    super.initState();

    final databaseReference =
        FirebaseDatabase.instance.ref().child('riderequest');
    databaseReference.once().then((DatabaseEvent snapshot) {
      final data = snapshot.snapshot.value;
      if (data != null) {
        Map<dynamic, dynamic> data =
            snapshot.snapshot.value as Map<dynamic, dynamic>;
        var keys = data.keys;
        for (var key in keys) {
          Auction auction = Auction(
            title: data[key]['fares'],
          );
          auctions.add(auction);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Auctions'),
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
                Map<dynamic, dynamic> rating =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                // Iterate through the ride history objects and build a list
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: rating.length,
                    // assending order
                    reverse: true,
                    itemBuilder: (context, index) {
                      var delivery = rating.values.elementAt(index);
                      return Card(
                        child: ListTile(
                            title: const Text(
                              'ORDER: 12342445',
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
                                      onPressed: () {},
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
                  child: Text('No Review Found!!!'),
                );
              }
            }));
  }
}
