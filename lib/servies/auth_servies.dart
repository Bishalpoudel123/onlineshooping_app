// lib/services/auth_services.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth      = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  /// LOGIN
  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// SIGNUP
  static Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Firestore ma name save garne
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name':      name.trim(),
        'email':     email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Firebase Auth profile update
      await credential.user!.updateDisplayName(name.trim());

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// GET USERNAME
  static Future<String> getCurrentUserName() async {
    final user = currentUser;
    if (user == null) return 'User';
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data()?['name'] ?? user.email?.split('@').first ?? 'User';
    } catch (_) {
      return user.email?.split('@').first ?? 'User';
    }
  }

  /// SIGN OUT
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ERROR HANDLER
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email registered छैन।';
      case 'wrong-password':
        return 'Password mismatch भयो।';
      case 'email-already-in-use':
        return 'Email already use भइसक्यो।';
      case 'weak-password':
        return 'Password कम्तिमा 6 characters राख्नुस्।';
      case 'invalid-email':
        return 'Valid email राख्नुस्।';
      default:
        return e.message ?? 'Something went wrong.';
    }
  }
}