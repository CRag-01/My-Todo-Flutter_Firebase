import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytodo/radiobwidget.dart';

class Description extends StatelessWidget {
  final String title, description;
  const Description({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Description'),),
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(title, style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold))
          ),
        Container(
            margin: EdgeInsets.all(10),
            child: Text(description, style: GoogleFonts.roboto())
        ),
        ])
      )
    );
  }
}
