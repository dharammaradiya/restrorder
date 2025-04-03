// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

List<String> Catagory = [
  "All",
  "Starter",
  "Soup",
  "Papad/Salad",
  "Pavbhaji",
  "Pulao",
  "Masala Dosa (Stuffed)",
  "Mysore Dosa (Gravy)",
  "Paper/Sada Dosa",
  "Noodles",
  "Rice",
  "Manchurian",
  "Fancy Dosa",
  "French Fries",
  "Pizza",
  "Sizzler",
  "Extra Dip"
];
var table = ['Table 1', 'Table 2', 'Table 3', 'Table 4', 'Table 5', 'Table 6'];

List<Color> Catagarycolor = [
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
  const Color.fromARGB(255, 75, 75, 211),
];

class Consts {
  static Map? concatMap;
}

int selectedIndex = 0;

var menu = [
  "Table 1",
  "Table 2",
  "Table 3",
  "Table 4",
  "Table 5",
  "Table 6",
];
var dropdownvalue = "";

// List of items in our dropdown menu

List color = [
  const Color.fromARGB(255, 158, 131, 68),
  const Color.fromARGB(255, 82, 64, 114),
  const Color.fromARGB(255, 43, 81, 120),
  const Color.fromARGB(255, 115, 115, 114),
  const Color.fromARGB(255, 66, 130, 113),
  const Color.fromARGB(255, 51, 51, 50),
];

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 800,
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextField(
          // controller: _email,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 10, right: 10.0),
                child: Icon(
                  Icons.search,
                  // fill: Checkbox.width,
                  color: Color.fromARGB(255, 0, 0, 2),
                ),
              ),
              fillColor: const Color.fromARGB(255, 242, 242, 242),
              filled: true,
              hintText: "Search",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(12)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(12))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// List<String> cartItem = [
//   "pavbhaji",
// ];



