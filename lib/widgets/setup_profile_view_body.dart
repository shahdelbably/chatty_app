import 'dart:io';
import 'package:chatty/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/views/home_view.dart';
import 'package:chatty/widgets/profile_picture_picker.dart';
import 'package:chatty/widgets/setup_button.dart';
import 'package:chatty/widgets/setup_profile_text_form_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetupProfileViewBody extends StatefulWidget {
  final User firebaseUser;

  const SetupProfileViewBody({super.key, required this.firebaseUser});

  @override
  State<SetupProfileViewBody> createState() => _SetupProfileViewBodyState();
}

class _SetupProfileViewBodyState extends State<SetupProfileViewBody> {
  final TextEditingController nameController = TextEditingController();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Text(
                'Welcome! Let’s personalize your profile 👋',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 40),

              ProfilePicturePicker(
                onImageSelected: (image) {
                  selectedImage = image;
                },
              ),
              const SizedBox(height: 40),

              SetupProfileTextFormFeild(
                hint: 'Enter your name',
                controller: nameController,
              ),
              const SizedBox(height: 30),

              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeView();
                        },
                      ),
                      (route) => false,
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  return SetupButton(
                    text:
                        state is AuthLoading ? 'Setting Up...' : 'Let’s Go! 🚀',
                    onTap: () {
                      if (selectedImage != null) {
                        BlocProvider.of<AuthCubit>(context).completeProfile(
                          name: nameController.text,
                          imageFile: selectedImage!,
                          firebaseUser: widget.firebaseUser,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a profile picture!'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
