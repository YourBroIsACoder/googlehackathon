// Mock Auth Service - For testing without Firebase
// Replace this with auth_service.dart when Firebase is configured

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'interfaces/i_auth_service.dart';

class AuthService implements IAuthService {
  AppUser? _currentUser;
  final _authController = StreamController<AppUser?>.broadcast();

  @override
  User? get currentUser => null; // Firebase User type - not used in mock

  @override
  Stream<User?> get authStateChanges {
    // Return a stream that emits null initially, then emits when user changes
    return _authController.stream.map((appUser) => null);
  }
  
  // Helper stream for AppUser changes (used internally)
  Stream<AppUser?> get appUserChanges => _authController.stream;

  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    // Mock delay to simulate network call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock authentication - accept any email/password
    _currentUser = AppUser(
      uid: 'mock_${email.hashCode}',
      email: email,
      displayName: email.split('@')[0],
      isAdmin: email.contains('admin'), // Admin if email contains 'admin'
      createdAt: DateTime.now(),
    );
    
    _authController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    // Mock delay to simulate network call
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = AppUser(
      uid: 'mock_${email.hashCode}',
      email: email,
      displayName: displayName,
      isAdmin: email.contains('admin'),
      createdAt: DateTime.now(),
    );
    
    _authController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    throw UnimplementedError('Google Sign-In not available in mock mode');
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authController.add(null);
  }

  @override
  Future<AppUser?> getCurrentUserData() async {
    return _currentUser;
  }
}

