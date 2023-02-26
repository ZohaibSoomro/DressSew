import 'package:flutter/material.dart';

const kTitleStyle = TextStyle(fontSize: 50, fontFamily: 'Georgia');
const kInputStyle = TextStyle(fontFamily: 'Georgia');
const kTextStyle = TextStyle(
    color: Colors.black54, fontFamily: 'Courier', fontWeight: FontWeight.w700);

const kTextFieldDecoration = InputDecoration(
  hintText: 'enter a value',
  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  enabledBorder: const OutlineInputBorder(
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

final Map<String, List<String>> menCategories = {
  "Formal": [
    "Dress Shirts",
    "Dress Pants",
    "Two Piece",
    "Three-Piece",
    "Vase Coats",
    "Coats",
    "Shervaani"
  ],
  "Casual": ["Shalwar Kameez"],
  "Cultural": ["Sindhi", "Punjabi", "Balochi", "Pakhtun"],
  "Others": ["Costumes"],
};

final Map<String, List<String>> ladiesCategories = {
  "Formal": [
    "Lehanga",
    "Frock",
    "Ghaghra Choli",
    "Gharara",
    "Sharara",
    "Maxi",
    "Fishtail",
    "Sari"
  ],
  "Casual": ["Kurti", "Shalwar Kameez", "Short Frock"],
  "Cultural": ["Sindhi", "Punjabi", "Balochi", "Pakhtun"],
  "Others": ["Costumes"],
};

final Map<String, List<String>> overallCategories = {
  "Gents": [
    ...?menCategories["Formal"],
    ...?ladiesCategories["Formal"],
  ],
  "Ladies": [...?menCategories["Formal"]]
};
