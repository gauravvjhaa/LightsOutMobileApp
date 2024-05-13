import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import this for kDebugMode

class DelayedExecution {
  static Future<void> executeWithDelay(
      BuildContext context, int milliseconds, String loadingMessage) async {
    // Show loading screen with a scaffold structure
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button during delay
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    loadingMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Game',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Delay execution for specified milliseconds
    await Future.delayed(Duration(milliseconds: milliseconds));

    // Close loading screen
    Navigator.of(context).pop();

    // Proceed with subsequent tasks after delay
    // Insert your code here to run after the delay
    if (kDebugMode) {
      print('System freeze for $milliseconds milliseconds completed. Proceeding with next tasks...');
    }
  }
}
