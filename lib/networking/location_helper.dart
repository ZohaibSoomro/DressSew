import 'package:dresssew/models/user_location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class LocationHelper {
  Location location = Location();

  Future<UserLocation?> getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(
            msg: "enable location service.", gravity: ToastGravity.CENTER);
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.denied) {
        Fluttertoast.showToast(
            msg: "location permission required.", gravity: ToastGravity.CENTER);
        return null;
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      if (locationData.latitude != null) {
        UserLocation location = UserLocation(
            longitude: locationData.longitude!,
            latitude: locationData.latitude!);
        return location;
      }
    }
    return null;
  }
}
