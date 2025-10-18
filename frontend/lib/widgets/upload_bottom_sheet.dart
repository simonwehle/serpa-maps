import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'dart:io';

class UploadBottomSheet extends StatelessWidget {
  const UploadBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: Material(
                  color: Colors.lightBlue,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      final picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (image != null) {
                        final bytes = await File(image.path).readAsBytes();
                        final data = await readExifFromBytes(bytes);

                        if (data.isEmpty) {
                          print("No EXIF data found");
                          return;
                        }

                        final latValues = data['GPS GPSLatitude']?.values;
                        final lonValues = data['GPS GPSLongitude']?.values;
                        final latRef = data['GPS GPSLatitudeRef']?.printable;
                        final lonRef = data['GPS GPSLongitudeRef']?.printable;

                        if (latValues == null ||
                            lonValues == null ||
                            latRef == null ||
                            lonRef == null) {
                          print("No GPS data found");
                          return;
                        }

                        final latRatios = latValues.toList();
                        final lonRatios = lonValues.toList();

                        double latitude = _toDecimal(latRatios);
                        double longitude = _toDecimal(lonRatios);

                        if (latRef != 'N') latitude = -latitude;
                        if (lonRef != 'E') longitude = -longitude;

                        print('Latitude: $latitude, Longitude: $longitude');
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

double _toDecimal(List<dynamic> ratios) {
  if (ratios.length < 3) return 0;
  final deg = ratios[0].toDouble();
  final min = ratios[1].toDouble();
  final sec = ratios[2].toDouble();
  return deg + (min / 60) + (sec / 3600);
}
