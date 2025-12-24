# Firebase Configuration Guide

## Step-by-Step Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `civic-complaint-platform` (or your preferred name)
4. Disable Google Analytics (optional, for free tier)
5. Click "Create project"

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Email/Password** provider
3. Enable **Google** provider:
   - Click on Google
   - Enable the provider
   - Add your support email
   - For web: Add your domain to authorized domains
   - Click "Save"
4. (Optional) Enable **Facebook** provider:
   - You'll need a Facebook App ID and App Secret
   - Follow Facebook's developer documentation to create an app
   - Add the App ID and Secret in Firebase
5. Click "Save" for each enabled provider

### 3. Create Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Choose a location (select closest to your users)
5. Click "Enable"

### 4. Set Up Firestore Security Rules

Go to **Firestore Database** > **Rules** and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Complaints collection
    match /complaints/{complaintId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
      allow delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
  }
}
```

Click "Publish"

### 5. Enable Firebase Storage

1. Go to **Storage**
2. Click "Get started"
3. Start in test mode
4. Choose same location as Firestore
5. Click "Done"

### 6. Set Up Storage Rules

Go to **Storage** > **Rules** and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /complaints/{complaintId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.resource.size < 5 * 1024 * 1024; // 5MB limit
    }
  }
}
```

Click "Publish"

### 7. Configure Web App

1. Go to **Project Settings** (gear icon)
2. Scroll to "Your apps"
3. Click web icon (`</>`)
4. Register app with nickname: "Civic Complaint Web"
5. Copy the Firebase configuration object
6. Update `lib/main.dart` with these values:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  ),
);
```

### 8. Configure Android App

1. In **Project Settings**, click Android icon
2. Register app with:
   - Package name: `com.example.civic_complaint_platform`
   - App nickname: "Civic Complaint Android"
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Update `android/build.gradle.kts` (project-level) to include:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0")
   }
   ```
6. Update `android/app/build.gradle.kts` to include at the bottom:
   ```kotlin
   apply plugin: 'com.google.gms.google-services'
   ```

### 9. Create Admin User

1. Run the app and register a user account
2. Go to **Firestore Database** > **users** collection
3. Find the user document (by UID)
4. Edit the document and add field:
   - Field: `isAdmin`
   - Type: `boolean`
   - Value: `true`
5. Save

### 10. Firebase Hosting (Optional for Web)

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login:
   ```bash
   firebase login
   ```

3. Initialize hosting:
   ```bash
   firebase init hosting
   ```
   - Select your Firebase project
   - Public directory: `build/web`
   - Configure as single-page app: Yes
   - Set up automatic builds: No

4. Build and deploy:
   ```bash
   flutter build web
   firebase deploy --only hosting
   ```

## Testing

1. Run the app: `flutter run`
2. Register a new user
3. Submit a test complaint
4. Check Firestore to see the complaint document
5. Check Storage to see uploaded images

## Troubleshooting

### Authentication Issues
- Ensure Email/Password is enabled in Firebase Console
- Check that Firebase config values are correct

### Firestore Permission Denied
- Verify security rules are published
- Check that user is authenticated

### Storage Upload Fails
- Verify Storage is enabled
- Check file size (must be < 5MB)
- Verify storage rules

### Location Not Working
- Check app permissions in device settings
- For web, ensure HTTPS is used (required for geolocation)

## Free Tier Monitoring

Monitor your usage in Firebase Console:
- **Firestore**: Usage tab shows read/write counts
- **Storage**: Storage tab shows usage
- **Authentication**: No limits on free tier

Stay within free tier limits to avoid charges!

