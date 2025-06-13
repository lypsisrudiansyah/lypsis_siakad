import 'package:flutter/material.dart';

extension WidgetAsSnackbarWidgetExtension on Widget {
  Future<void> snackbar(BuildContext context) async {
    var snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actionOverflowThreshold: 0.0,
      behavior: SnackBarBehavior.fixed,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: this,
          )
        ],
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> dialog(
    BuildContext context, {
    bool barrierDismissible = true,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Wrap(
            children: [
              Center(
                child: this,
              )
            ],
          ),
        );
      },
    );
  }
}
