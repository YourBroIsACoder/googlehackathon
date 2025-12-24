# Quick Start Guide

## Prerequisites Checklist

- [ ] Flutter SDK installed (3.10.4+)
- [ ] Firebase account created
- [ ] Google Cloud account (for Maps API)
- [ ] Android Studio / VS Code with Flutter extensions

## Setup Steps (5 minutes)

### 1. Clone and Install Dependencies

```bash
cd civic_complaint_platform
flutter pub get
```

### 2. Firebase Setup (3 minutes)

Follow the detailed guide in `FIREBASE_SETUP.md` or:

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project

2. **Enable Services**
   - Authentication: Enable Email/Password
   - Firestore: Create database (test mode)
   - Storage: Enable with default rules

3. **Configure Android**
   - Download `google-services.json` from Firebase Console
   - Place in `android/app/` directory

4. **Configure Web**
   - Firebase SDK is already included in `web/index.html`
   - Update Firebase config in Firebase Console if needed

### 3. Google Maps API (2 minutes)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps SDK for Android and Maps JavaScript API
3. Create API key
4. Update:
   - `android/app/src/main/AndroidManifest.xml`: Replace `YOUR_GOOGLE_MAPS_API_KEY`
   - `web/index.html`: Replace `YOUR_GOOGLE_MAPS_API_KEY`

### 4. Create Admin User

1. Run the app: `flutter run`
2. Register a user account
3. Go to Firestore Console > `users` collection
4. Find your user document and set `isAdmin: true`

### 5. Run the App

```bash
# For Web
flutter run -d chrome

# For Android
flutter run
```

## Testing the App

### As Citizen:
1. Register/Login
2. Click "Submit Complaint"
3. Fill in details, allow location access
4. Add photo (optional)
5. Submit
6. View in "My Complaints"

### As Admin:
1. Login with admin account
2. Go to "Manage Complaints"
3. View complaints by status
4. Click complaint to view details
5. Update priority, status, and notes
6. Mark as resolved

## Common Issues

### Firebase Not Initialized
- Check `google-services.json` is in `android/app/`
- Verify Firebase project settings

### Location Not Working
- Grant location permissions
- For web: Use HTTPS (required for geolocation)

### Maps Not Loading
- Verify Google Maps API key is correct
- Check API is enabled in Google Cloud Console

### Image Upload Fails
- Check Firebase Storage is enabled
- Verify file size < 5MB
- Check storage security rules

## Next Steps

- Read `README.md` for detailed documentation
- Check `FIREBASE_SETUP.md` for Firebase configuration
- Customize UI colors and branding
- Add more complaint categories
- Set up Firebase Hosting for web deployment

## Support

- Flutter Docs: https://docs.flutter.dev/
- Firebase Docs: https://firebase.google.com/docs
- Google Maps Docs: https://developers.google.com/maps

