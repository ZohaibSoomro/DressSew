import 'package:flutter/material.dart';

const kTitleStyle = TextStyle(fontSize: 50, fontFamily: 'Georgia');
const kInputStyle = TextStyle(fontFamily: 'Georgia');
const kTextStyle = TextStyle(
    color: Colors.black54, fontFamily: 'Courier', fontWeight: FontWeight.w700);

const kTextFieldDecoration = InputDecoration(
  hintText: 'enter a value',
  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
);

const ladiesExpertise = [
  "Blouse",
  "Sweater",
  "Trouser Shirt",
  "Gowns",
  "Cultural outfit",
  "Churidar",
  "Frock",
  "Costumes",
  "Coats"
];
const menExpertise = [
  "Suits",
  "Uniforms",
  "Cultural outfit",
  "Trouser Shirt",
  "Coats",
  "WaistCoat",
  "Shalwar Kameez",
  "Casual",
  "Costumes",
  "Party wear"
];
final overallExpertise = [
  "Casual",
  "Traditional",
  "Formal",
  "Party wear",
  "Costumes",
  ...menExpertise,
  ...ladiesExpertise
];
