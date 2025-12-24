import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/interfaces/interfaces.dart';
import '../config/service_locator.dart';

class AuthProvider with ChangeNotifier {
  IAuthService get _authService => ServiceLocator.instance.authService;
  AppUser? _user;
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // Get current user data
    _user = await _authService.getCurrentUserData();
    notifyListeners();
    
    // Listen for auth state changes
    // Note: This works for both Firebase and mock implementations
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
      } else {
        _user = await _authService.getCurrentUserData();
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      debugPrint('🔐 Attempting sign in with email: $email');
      _user = await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      
      if (_user != null) {
        debugPrint('✅ Sign in successful! User: ${_user!.email}, Admin: ${_user!.isAdmin}');
      } else {
        debugPrint('❌ Sign in failed - no user returned');
      }
      
      notifyListeners();
      return _user != null;
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String displayName) async {
    _isLoading = true;
    notifyListeners();
    try {
      debugPrint('📝 Attempting registration with email: $email');
      _user = await _authService.registerWithEmailAndPassword(email, password, displayName);
      _isLoading = false;
      
      if (_user != null) {
        debugPrint('✅ Registration successful! User: ${_user!.email}');
      } else {
        debugPrint('❌ Registration failed - no user returned');
      }
      
      notifyListeners();
      return _user != null;
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }
}

