

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showStyledPopLoading(BuildContext context) {
  showDialog(
    context:context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Replace with your desired loading indicator
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),],
          ),
        ),
      );
    },
  );
}
void showNetworkErrorAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, //User must explicitly acknowledge the error
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red), // Visually indicate network error
            SizedBox(width: 8),Text('Network Error'),
          ],
        ),
        content: const Text(
          'No internet connection. Please check your network and try again.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              // You might want to add logic here to retry the failed operation
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
void showTokenErrorAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,builder: (BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text('Session Expired'),
        ],),
      content: const Text(
        'Your session has expired. Please log in again.',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  },
  );
}
void showUndefinedErrorAlert(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,builder: (BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Text('An Error Occurred'),
        ],
      ),content: const Text(
      'Something went wrong. Please try again later.',
      style: TextStyle(fontSize: 16),
    ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // You might want to add logic here to handle the undefined error,
            // such as logging the error or navigating to a support screen.
          },
          child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  },
  );
}



