import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'interfaces/i_auth_service.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Google Sign-In - only initialize if properly configured
  GoogleSignIn? _googleSignIn;
  
  AuthService() {
    // Only initialize Google Sign-In if we have proper web configuration
    // For now, we'll disable it to avoid the Client ID error
    // _googleSignIn = GoogleSignIn();
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Try to get user data, but handle offline scenarios
        try {
          return await _getUserData(credential.user?.uid);
        } catch (firestoreError) {
          debugPrint('Firestore offline, creating temporary user data: $firestoreError');
          // Create temporary user data if Firestore is offline
          return AppUser(
            uid: credential.user!.uid,
            email: credential.user!.email ?? email,
            displayName: credential.user!.displayName ?? email.split('@')[0],
            photoUrl: credential.user!.photoURL,
            isAdmin: false,
            createdAt: DateTime.now(),
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        
        final appUser = AppUser(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          isAdmin: false,
          createdAt: DateTime.now(),
        );

        // Try to save to Firestore, but don't fail if offline
        try {
          await _firestore.collection('users').doc(credential.user!.uid).set(appUser.toMap());
          debugPrint('✅ User data saved to Firestore');
        } catch (firestoreError) {
          debugPrint('⚠️ Firestore offline, user data will sync later: $firestoreError');
        }
        
        return appUser;
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Check if Google Sign-In is properly configured
      if (_googleSignIn == null) {
        throw Exception('Google Sign-In not configured for web. Please add Client ID to web/index.html');
      }
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Check if user document exists, create if not
        final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        
        AppUser appUser;
        if (!userDoc.exists) {
          // Create new user document
          appUser = AppUser(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            displayName: userCredential.user!.displayName ?? googleUser.displayName ?? 'User',
            photoUrl: userCredential.user!.photoURL,
            isAdmin: false,
            createdAt: DateTime.now(),
          );
          await _firestore.collection('users').doc(userCredential.user!.uid).set(appUser.toMap());
        } else {
          // Load existing user data
          appUser = AppUser.fromMap(userDoc.data()!);
        }
        
        return appUser;
      }
      
      return null;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<AppUser?> _getUserData(String? uid) async {
    if (uid == null) return null;

    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return AppUser.fromMap(userDoc.data()!);
    } else {
      // Create user document if it doesn't exist
      final user = _auth.currentUser;
      if (user != null) {
        final appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
          isAdmin: false,
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(uid).set(appUser.toMap());
        return appUser;
      }
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUserData() async {
    if (currentUser == null) return null;
    return await _getUserData(currentUser!.uid);
  }
}

