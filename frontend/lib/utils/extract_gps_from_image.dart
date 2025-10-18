import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'dart:io';

Future<(double, double)?> extractGpsFromImage(XFile image) async {
  final bytes = await File(image.path).readAsBytes();
  final data = await readExifFromBytes(bytes);

  if (data.isEmpty) {
    return null; // No EXIF data
  }

  final latValues = data['GPS GPSLatitude']?.values;
  final lonValues = data['GPS GPSLongitude']?.values;
  final latRef = data['GPS GPSLatitudeRef']?.printable;
  final lonRef = data['GPS GPSLongitudeRef']?.printable;

  if (latValues == null ||
      lonValues == null ||
      latRef == null ||
      lonRef == null) {
    return null; // No GPS data
  }

  final latRatios = latValues.toList();
  final lonRatios = lonValues.toList();

  double latitude = _toDecimal(latRatios);
  double longitude = _toDecimal(lonRatios);

  if (latRef != 'N') latitude = -latitude;
  if (lonRef != 'E') longitude = -longitude;

  return (latitude, longitude);
}

double _toDecimal(List<dynamic> ratios) {
  if (ratios.length < 3) return 0;
  final deg = ratios[0].toDouble();
  final min = ratios[1].toDouble();
  final sec = ratios[2].toDouble();
  return deg + (min / 60) + (sec / 3600);
}
