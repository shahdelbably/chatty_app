import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionToLoginOrSignUp extends StatelessWidget {
  const QuestionToLoginOrSignUp({
    super.key,
    required this.question,
    required this.answer,
    required this.onTap,
  });

  final String question;
  final String answer;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(
            color: Color(0xFFB0AEB1),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              color: whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
