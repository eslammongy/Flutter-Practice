import 'package:flutter/material.dart';

/// displaying a customized snackbar
void displaySnackBar(
  BuildContext context,
  String msg, {
  bool hasError = false,
}) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
    content: Text(
      msg,
      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
    ),
    margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: hasError ? theme.colorScheme.error : Colors.green,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
