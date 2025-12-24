import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../services/interfaces/interfaces.dart';
import '../services/auth_service.dart' as firebase_auth;
import '../services/auth_service_mock.dart' as mock_auth;
import '../services/complaint_service.dart' as firebase_complaint;
import '../services/complaint_service_mock.dart' as mock_complaint;
import '../services/storage_service_mock.dart' as mock_storage;
import 'firebase_config.dart';

/// Service locator for dependency injection
/// Automatically selects Firebase or mock services based on configuration
class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();
  
  ServiceLocator._();

  bool _isInitialized = false;
  bool _useFirebase = false;
  String? _initializationError;

  // Service instances
  IAuthService? _authService;
  IComplaintService? _complaintService;
  IStorageService? _storageService;

  /// Initialize services based on Firebase configuration
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if Firebase is configured
      if (FirebaseConfig.isConfigured()) {
        debugPrint('Firebase configuration detected, attempting to initialize...');
        
        // Try to initialize Firebase
        await Firebase.initializeApp(
          options: FirebaseConfig.getCurrentPlatformOptions(),
        );
        
        _useFirebase = true;
        debugPrint('Firebase initialized successfully');
      } else {
        debugPrint('Firebase not configured, using mock services');
        _useFirebase = false;
      }
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('Falling back to mock services');
      _useFirebase = false;
      _initializationError = e.toString();
    }

    // Initialize service instances
    _initializeServices();
    _isInitialized = true;
  }

  void _initializeServices() {
    if (_useFirebase) {
      // Initialize Firebase services
      debugPrint('🔥 Initializing Firebase services');
      _authService = firebase_auth.AuthService();
      _complaintService = firebase_complaint.ComplaintService();
      _storageService = mock_storage.StorageService(); // TODO: Implement Firebase Storage
    } else {
      // Initialize mock services
      debugPrint('🔧 Initializing mock services');
      _authService = mock_auth.AuthService();
      _complaintService = mock_complaint.ComplaintService();
      _storageService = mock_storage.StorageService();
    }
  }

  /// Get authentication service
  IAuthService get authService {
    if (!_isInitialized) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _authService!;
  }

  /// Get complaint service
  IComplaintService get complaintService {
    if (!_isInitialized) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _complaintService!;
  }

  /// Get storage service
  IStorageService get storageService {
    if (!_isInitialized) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _storageService!;
  }

  /// Check if Firebase services are being used
  bool get isUsingFirebase => _useFirebase;

  /// Check if there was an initialization error
  bool get hasInitializationError => _initializationError != null;

  /// Get initialization error message
  String? get initializationError => _initializationError;

  /// Reset the service locator (for testing)
  void reset() {
    _instance = null;
  }
}