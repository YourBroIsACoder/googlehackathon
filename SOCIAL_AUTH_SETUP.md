# Social Authentication Setup Guide

## ✅ What's Already Implemented

Your app now includes:
- **Google Sign-In** - Fully implemented and ready to use
- **Facebook Sign-In** - UI placeholder (can be implemented later)
- **Email/Password** - Original authentication method
- **Automatic service detection** - Switches between Firebase and mock services

## 🚀 Quick Firebase Setup

### Step 1: Get Your Firebase Config
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **civic-complaint-platform**
3. Go to **Project Settings** (gear icon) > **General**
4. Scroll to "Your apps" and click **Web** (`</>`)
5. Copy the config object that looks like this:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

### Step 2: Update Your App Config
1. Open `lib/config/firebase_config.dart`
2. Replace the placeholder values with your actual Firebase config:

```dart
static const FirebaseOptions webOptions = FirebaseOptions(
  apiKey: 'AIza...', // Your actual API key
  appId: '1:123456789:web:abc123', // Your actual App ID
  messagingSenderId: '123456789', // Your actual sender ID
  projectId: 'your-project-id', // Your actual project ID
  authDomain: 'your-project.firebaseapp.com',
  storageBucket: 'your-project.appspot.com',
);
```

### Step 3: Enable Authentication Methods
1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. **Enable Email/Password**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

3. **Enable Google Sign-In**:
   - Click on "Google"
   - Toggle "Enable"
   - Add your support email (required)
   - Click "Save"

### Step 4: Set Up Firestore Database
1. Go to **Firestore Database**
2. Click "Create database"
3. Select **"Start in test mode"** (for development)
4. Choose a location close to your users
5. Click "Enable"

### Step 5: Enable Firebase Storage
1. Go to **Storage**
2. Click "Get started"
3. Select **"Start in test mode"**
4. Choose the same location as Firestore
5. Click "Done"

## 🧪 Testing Your Setup

### Test with Mock Services (Default)
```bash
flutter run
```
- App will show: "🔧 Using mock services for development"
- You can test the UI and functionality with fake data

### Test with Firebase Services
1. Complete the Firebase setup above
2. Run the app:
```bash
flutter run
```
- App will show: "✅ Using Firebase services"
- Google Sign-In will work with real authentication
- Data will be stored in Firestore

## 🎯 What You Get

### Authentication Options
- **Email/Password Registration**: Traditional signup
- **Google Sign-In**: One-click authentication with Google account
- **Facebook Sign-In**: UI ready (implementation can be added later)

### Automatic Features
- **User Profile Creation**: Automatic Firestore user documents
- **Admin Detection**: Set `isAdmin: true` in Firestore for admin users
- **Real-time Data**: All complaint data synced across devices
- **Image Storage**: Photos uploaded to Firebase Storage

## 🔧 Advanced Configuration

### Add Facebook Sign-In (Optional)
1. Create a Facebook App at [developers.facebook.com](https://developers.facebook.com)
2. Get your App ID and App Secret
3. In Firebase Console > Authentication > Sign-in method > Facebook
4. Add your Facebook App ID and Secret
5. Update the app code to implement Facebook authentication

### Create Admin Users
1. Register a user account in your app
2. Go to Firebase Console > Firestore Database
3. Find the user document in the `users` collection
4. Edit the document and add: `isAdmin: true`
5. That user will now have admin access

### Security Rules (Already Configured)
The app includes proper Firestore security rules:
- Users can only see their own complaints
- Admins can see and modify all complaints
- Authentication required for all operations

## 🚨 Troubleshooting

### "Using mock services" message
- Check that you've updated `firebase_config.dart` with real values
- Ensure all placeholder values are replaced

### Google Sign-In not working
- Verify Google provider is enabled in Firebase Console
- Check that your domain is in authorized domains
- For localhost testing, add `localhost` to authorized domains

### Permission denied errors
- Ensure Firestore security rules are published
- Check that users are properly authenticated

## 📱 Ready to Deploy

Once everything works:
1. **Web**: Use Firebase Hosting for easy deployment
2. **Android**: Add `google-services.json` to `android/app/`
3. **Production**: Switch Firestore to production mode with proper security rules

Your civic complaint platform now has modern social authentication! 🎉