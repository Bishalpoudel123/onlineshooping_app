// lib/services/auth_services.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  /// LOGIN
  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('[AuthService] Login attempt for email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print('[AuthService] Login successful for UID: ${credential.user?.uid}');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('[AuthService] Login failed (${e.code}): ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      print('[AuthService] Unexpected login error: $e');
      rethrow;
    }
  }

  /// SIGNUP
  static Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      print("[AuthService] Signup started for email: $email");

      // Step 1: Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print("[AuthService] Auth user created with UID: ${credential.user?.uid}");

      if (credential.user == null) {
        throw Exception('User creation failed: User is null');
      }

      final uid = credential.user!.uid;

      // Step 2: Save user data to Firestore
      try {
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print("[AuthService] Firestore user document created successfully");
      } catch (firestoreError) {
        print("[AuthService] Firestore error: $firestoreError");
        rethrow;
      }

      // Step 3: Update profile
      try {
        await credential.user!.updateDisplayName(name.trim());
        print("[AuthService] Display name updated successfully");
      } catch (profileError) {
        print("[AuthService] Profile update error: $profileError");
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print("[AuthService] FirebaseAuth error (${e.code}): ${e.message}");
      rethrow;
    } catch (e) {
      print("[AuthService] Unexpected error: $e");
      rethrow;
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
    try {
      await _auth.signOut();
      print('[AuthService] User signed out successfully');
    } catch (e) {
      print('[AuthService] Sign out error: $e');
      rethrow;
    }
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// ERROR HANDLER
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'weak-password':
        return 'Password must be at least 6 characters long.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
