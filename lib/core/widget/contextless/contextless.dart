import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get currentContext => navigatorKey.currentContext!;

//snackbar success
ss(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: successColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

//snackbar error
se(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: dangerColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

//snackbar info
si(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: infoColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

//snackbar warning
sw(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: warningColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

//snackbar primary
sp(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: primaryColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

//snackbar secondary
ssn(String message) {
  var snackbar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: secondaryColor,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
}

// CONFIRMATION DIALOG
Future<bool> confirm(String message) async {
  bool result = false;
  await showDialog<bool>(
    context: currentContext,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              result = true;
              back();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );

  return result;
}

// ALERT DIALOG
Future<void> alert(String message) async {
  await showDialog(
    context: currentContext,
    builder: (context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// NAVIGATION
Future to(Widget page) async {
  await Navigator.push(
    currentContext,
    MaterialPageRoute(builder: (context) => page),
  );
}

Future offAll(Widget page) async {
  //clear all routes
  await Navigator.pushAndRemoveUntil(
    currentContext,
    MaterialPageRoute(builder: (context) => page),
    (route) => false, // Hapus semua route sebelumnya
  );
}

Future back() async {
  Navigator.pop(currentContext);
}

// LOADING
void showLoading() {
  showDialog(
    context: currentContext,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoading() {
  Navigator.of(currentContext).pop();
}

Widget rowAction({
  required Widget child,
  String? confirmMessage,
  required Function onDismiss,
}) {
  return Dismissible(
    key: UniqueKey(),
    background: Container(
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    confirmDismiss: (direction) async {
      final confirmed = await confirm(
          confirmMessage ?? 'Are you sure you want to delete this item?');

      if (confirmed) {
        onDismiss();
      }

      return confirmed;
    },
    child: child,
  );
}
