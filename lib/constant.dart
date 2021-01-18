import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  fillColor: Colors.white,
  focusColor: Colors.black,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF90CAFB), width: 2),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

const textSearchDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF90CAFB), width: 2),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    prefixIcon: Icon(Icons.search, color: Colors.black));
