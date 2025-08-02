import 'package:chatty/helper/colors.dart';
import 'package:chatty/widgets/logo_sign.dart';
import 'package:chatty/widgets/sign_up_part.dart';
import 'package:flutter/material.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LogoInSign(),

          Stack(
            children: [
              SignUpPart(),
              Positioned(
                bottom: -60,
                right: -35,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
