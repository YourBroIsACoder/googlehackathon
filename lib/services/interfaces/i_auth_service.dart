import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

/// Abstract interface for authentication services
/// Provides a common contract for both Firebase and mock implementations
abstract class IAuthService {
  /// Stream of Firebase User authentication state changes
  Stream<User?> get authStateChanges;
  
  /// Get the current Firebase User (null if not authenticated)
  User? get currentUser;
  
  /// Sign in with email and password
  /// Returns AppUser on success, null on failure
  /// Throws Exception on error
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  
  /// Register new user with email, password, and display name
  /// Returns AppUser on success, null on failure
  /// Throws Exception on error
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  );
  
  /// Sign in with Google (optional implementation)
  /// Returns AppUser on success, null on failure
  /// Throws Exception or UnimplementedError
  Future<AppUser?> signInWithGoogle();
  
  /// Sign out current user
  /// Throws Exception on error
  Future<void> signOut();
  
  /// Get current user's profile data from database
  /// Returns AppUser if authenticated and data exists, null otherwise
  Future<AppUser?> getCurrentUserData();
}