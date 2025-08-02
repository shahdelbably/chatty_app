import 'package:chatty/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatty/firebase_options.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/services/auth_service.dart';
import 'package:chatty/services/cloudinary_service.dart';
import 'package:chatty/services/firestore_service.dart';
import 'package:chatty/views/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChattyApp());
}

class ChattyApp extends StatelessWidget {
  const ChattyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthCubit(
            authService: AuthService(),
            cloudinaryService: CloudinaryService(),
            firestoreService: FirestoreService(),
          ),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: whiteColor,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
      ),
    );
  }
}
