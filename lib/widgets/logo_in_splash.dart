import 'package:chatty/helper/asset_data.dart';
import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoInSplash extends StatelessWidget {
  const LogoInSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logoHero',

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetData.logo, width: 120),

          Text(
            'Chatty',
            style: GoogleFonts.pacifico(
              fontSize: 28,
              color: primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
