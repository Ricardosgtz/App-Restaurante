import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatelessWidget {

  String text;
  Function() onPressed;
  Color color;

  DefaultButton({
    required this.text,
    required this.onPressed,
    this.color = AppTheme.primaryColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
         onPressed();
        }, 
        style: ElevatedButton.styleFrom(
          backgroundColor: color
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}