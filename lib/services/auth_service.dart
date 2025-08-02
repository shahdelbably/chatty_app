import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  Stream<User?> get userChanges => _auth.authStateChanges();
  Future<User?> signup(String email, String password) async {
    final authCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authCredential.user;
  }

  Future<User?> login(String email, String password) async {
    final authCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authCredential.user;
  }

  Future<void> setupProfile({
    required String displayName,
    required String photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoUrl);
      await user.reload();
    }
  }
}
