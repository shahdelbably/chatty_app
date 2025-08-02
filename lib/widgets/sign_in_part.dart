import 'package:chatty/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/helper/show_snack_bar.dart';
import 'package:chatty/views/home_view.dart';
import 'package:chatty/views/sign_up_view.dart';
import 'package:chatty/widgets/auth_text_form_field.dart';
import 'package:chatty/widgets/main_button_in_auth.dart';
import 'package:chatty/widgets/question_to_login_or_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPart extends StatelessWidget {
  SignInPart({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                AuthTextFormField(
                  title: 'Email',
                  controller: emailController,
                  hint: 'Enter your email',
                  isPasswordField: false,
                  prefixIcon: const Icon(Icons.email, color: greyColor),
                ),
                const SizedBox(height: 12),
                AuthTextFormField(
                  title: "Password",
                  controller: passwordController,
                  hint: 'Enter your Password',
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF92929D)),
                ),
                const SizedBox(height: 45),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeView();
                          },
                        ),
                      );
                    } else if (state is AuthFailure) {
                      showSnackBar(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return MainButtonInAuth(
                      text: state is AuthLoading ? 'Loading...' : 'Login',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                QuestionToLoginOrSignUp(
                  question: 'You don’t have an account?',
                  answer: 'Sign Up',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpView();
                        },
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
