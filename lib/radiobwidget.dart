import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  TodoWidget({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        child: Row(
          children: [
            Container(

              width: 20.0,
              height: 20.0,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: isDone ? Colors.indigo : Colors.transparent,
                  borderRadius: BorderRadius.circular(5.0),
                  border: isDone ? null : Border.all(
                    color: Colors.white,
                    width: 1.5
                  )

              ),
              child: Image(
                image: AssetImage(
                  'assets/images/check_icon.png'
                ),
              ),
            ),
            Text(
            text,
            style: TextStyle(
              color: isDone ? Colors.white : Colors.white12,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),),
          ],
        ),
      ),
    );
  }
}
