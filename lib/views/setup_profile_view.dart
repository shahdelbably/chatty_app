import 'package:chatty/widgets/setup_profile_view_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetupProfileView extends StatelessWidget {
  const SetupProfileView({super.key, required this.firebaseUser});
  final User firebaseUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SetupProfileViewBody(firebaseUser: firebaseUser));
  }
}
