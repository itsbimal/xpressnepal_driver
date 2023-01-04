import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xpressnepal/model/address.dart';

class AppData extends ChangeNotifier {
  var verification = "";
  void setVerification(String ver) {
    verification = ver;
  }

  Address? destinationAddress;
  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  String earnings = "0";
  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  String historylength = "0";
  void updateHistoryLength(String newHistoryLength) {
    historylength = newHistoryLength;
    notifyListeners();
  }

  List<String> triphistorykeys = [];
  void updateTripHistoryKeys(List<String> newTripHistoryKeys) {
    triphistorykeys = newTripHistoryKeys;
    notifyListeners();
  }

  LatLng? driverPickUpLocation;
  void updateDriverPickUpLocation(LatLng pos) {
    driverPickUpLocation = LatLng(pos.latitude, pos.longitude);
    notifyListeners();
  }

  String? esewa_qr_url = "";
  void updateEsewaQrUrl(String newEsewaQrUrl) {
    esewa_qr_url = newEsewaQrUrl;
    notifyListeners();
  }

  String? wallet_balance = "0.00";
  void updateWalletBalance(String newWalletBalance) {
    wallet_balance = newWalletBalance;
    notifyListeners();
  }

  String? set_request_id = "";
  void updateSetRequestId(String newSetRequestId) {
    set_request_id = newSetRequestId;
    notifyListeners();
  }

  int? load_amount = 0;
  void updateLoadAmount(int? newLoadAmount) {
    load_amount = int.parse(newLoadAmount.toString());
    notifyListeners();
  }
}
