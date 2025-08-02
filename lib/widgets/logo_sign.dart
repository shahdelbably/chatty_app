import 'package:chatty/helper/asset_data.dart';
import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoInSign extends StatelessWidget {
  const LogoInSign({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Center(
        child: Hero(
          tag: 'logoHero',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetData.logo, width: 120),
              Text(
                'Chatty',
                style: GoogleFonts.pacifico(
                  fontSize: 24,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
