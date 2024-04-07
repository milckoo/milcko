import 'package:flutter/material.dart';

void showSnackbar(BuildContext context,String content) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}