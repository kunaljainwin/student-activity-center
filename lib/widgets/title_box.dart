import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget titleBox(String title) {
  return Wrap(
    children: [
      const SizedBox(height: 24),
      Chip(
        label: Text(
          title,
          // textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      const SizedBox(height: 8),
    ],
  );
}
