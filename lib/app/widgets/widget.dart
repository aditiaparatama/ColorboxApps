import 'package:flutter/material.dart';

Container searchWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 0, right: 10),
    width: MediaQuery.of(context).size.width,
    height: 45,
    child: TextField(
      autofocus: true,
      onChanged: (value) {
        // ignore: avoid_print
        print(value);
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey.shade400),
        labelText: "Search...",
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
