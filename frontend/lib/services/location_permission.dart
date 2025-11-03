import 'package:permission_handler/permission_handler.dart';

Future requestLocationPermission() async {
  var permission = await Permission.location.request();
  if (permission.isGranted) {
    return true;
  } else {
    return false;
  }
}

Future<bool> checkLocationServiceStatus() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    return false;
  } else {
    return true;
  }
}
