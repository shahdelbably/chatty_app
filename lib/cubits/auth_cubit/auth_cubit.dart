import 'dart:io';
import 'package:chatty/services/auth_service.dart';
import 'package:chatty/services/cloudinary_service.dart';
import 'package:chatty/services/firestore_service.dart'; // هنضيف الخدمة دي
import 'package:chatty/models/user_model.dart'; // وهنضيف الموديل ده
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final CloudinaryService cloudinaryService;
  final FirestoreService firestoreService;

  AuthCubit({
    required this.authService,
    required this.cloudinaryService,
    required this.firestoreService,
  }) : super(AuthInitial());

  Future<void> signup({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final User? user = await authService.signup(email, password);
      if (user != null) {
        emit(AuthSuccessWithUser(user));
      } else {
        emit(AuthFailure("Sign up failed, user is null."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "An unexpected error occurred."));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final User? user = await authService.login(email, password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Login failed, user is null."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "An unexpected error occurred."));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> completeProfile({
    required String name,
    required File imageFile,
    required User firebaseUser,
  }) async {
    emit(AuthLoading());
    try {
      String imageUrl = await cloudinaryService.uploadImage(imageFile);
      await authService.setupProfile(displayName: name, photoUrl: imageUrl);

      final userModel = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: firebaseUser.email,
        imageUrl: imageUrl,
        lastMessage: null,
        unreadCounter: 0,
      );
      await firestoreService.saveUser(userModel.toMap());

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthFailure(e.message ?? "Error updating profile in Firebase Auth."),
      );
    } catch (e) {
      emit(AuthFailure('Error completing profile: $e'));
    }
  }
}
