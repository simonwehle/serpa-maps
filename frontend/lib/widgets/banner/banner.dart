import 'package:flutter/material.dart';
import 'package:serpa_maps/utils/keys.dart';

void showBanner(String message) {
  //, {bool isError = false}
  rootMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      // backgroundColor: isError ? Colors.red : null,
    ),
  );
}
