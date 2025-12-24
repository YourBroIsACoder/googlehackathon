import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration class
/// Contains all Firebase project settings
/// 
/// SETUP INSTRUCTIONS:
/// 1. Go to Firebase Console: https://console.firebase.google.com/
/// 2. Create a new project or select existing one
/// 3. Go to Project Settings > General > Your apps
/// 4. Click "Add app" and select Web (</>) 
/// 5. Register your app with nickname "Civic Complaint Web"
/// 6. Copy the config values and replace the placeholders below
/// 7. Enable Authentication providers in Firebase Console:
///    - Go to Authentication > Sign-in method
///    - Enable Email/Password
///    - Enable Google (requires OAuth consent screen setup)
///    - Enable Facebook (requires Facebook App ID and secret)
///    - Enable other providers as needed
/// 8. Create Firestore Database in test mode
/// 9. Enable Firebase Storage
/// 10. For Google Sign-In: Add your domain to authorized domains in Authentication settings
class FirebaseConfig {
  static const FirebaseOptions webOptions = FirebaseOptions(
  apiKey: "YOUR_FIREBASE_API_KEY",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.firebasestorage.app",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
  );

  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY', // Replace with your Android API key
    appId: 'YOUR_ANDROID_APP_ID', // Replace with your Android App ID
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID', // Same as web
    projectId: 'YOUR_PROJECT_ID', // Same as web
    storageBucket: 'YOUR_PROJECT_ID.appspot.com', // Same as web
  );

  /// Check if Firebase is properly configured
  /// Returns true if all required fields are filled
  static bool isConfigured() {
    const webConfig = webOptions;
    
    // Check if placeholder values are still present
    if (webConfig.apiKey == 'YOUR_API_KEY' ||
        webConfig.appId == 'YOUR_APP_ID' ||
        webConfig.projectId == 'YOUR_PROJECT_ID') {
      return false;
    }
    
    // Check if required fields are not empty
    if (webConfig.apiKey.isEmpty ||
        webConfig.appId.isEmpty ||
        webConfig.projectId.isEmpty) {
      return false;
    }
    
    return true;
  }

  /// Get Firebase options for current platform
  static FirebaseOptions getCurrentPlatformOptions() {
    // For now, return web options
    // In a real app, you'd detect platform and return appropriate options
    return webOptions;
  }
}