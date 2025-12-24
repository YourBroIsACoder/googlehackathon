# Quick Test Guide

## 🚨 Current Status

Your Firebase is configured and working! The error you saw was from Google Sign-In trying to initialize without proper web configuration. I've temporarily disabled Google Sign-In to fix the navigation issue.

## ✅ What Works Now

- **Email/Password Authentication** - Fully working with Firebase
- **User Registration** - Creates real user accounts in Firebase
- **Firestore Integration** - User data stored in Firebase
- **Automatic Navigation** - Should work properly now

## 🧪 Test Steps

### 1. Test Email/Password Registration
1. Run the app: `flutter run`
2. Click "Don't have an account? Register"
3. Fill in the form with:
   - Name: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
4. Click "Register"
5. Should navigate to Citizen Home Screen

### 2. Test Email/Password Login
1. If you're logged in, sign out first
2. On login screen, enter:
   - Email: `test@example.com`
   - Password: `password123`
3. Click "Login"
4. Should navigate to Citizen Home Screen

### 3. Create Admin User
1. Register a user (or use existing one)
2. Go to [Firebase Console](https://console.firebase.google.com/)
3. Go to Firestore Database
4. Find the user document in `users` collection
5. Edit the document and add field:
   - Field: `isAdmin`
   - Type: `boolean`
   - Value: `true`
6. Save and login with that user
7. Should navigate to Admin Home Screen

## 🔧 Enable Google Sign-In Later (Optional)

To enable Google Sign-In for web, you need to:

1. **Get OAuth Client ID**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Select your Firebase project
   - Go to APIs & Services > Credentials
   - Create OAuth 2.0 Client ID for Web application
   - Add your domain to authorized origins

2. **Add to web/index.html**:
   ```html
   <meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
   ```

3. **Update AuthService**:
   - Uncomment the GoogleSignIn initialization
   - Update login/register screens to enable the buttons

## 🎯 Expected Behavior

- **Login Success**: Navigates to appropriate home screen (Citizen/Admin)
- **Registration Success**: Creates user in Firebase and navigates to Citizen Home
- **Console Logs**: Should show "✅ Using Firebase services"
- **Firebase Console**: Should see user documents in Firestore

## 🚨 If Still Having Issues

1. **Check Console Logs**: Look for any other errors
2. **Check Firebase Console**: Verify user was created in Authentication tab
3. **Check Network Tab**: See if Firebase requests are successful
4. **Try Mock Mode**: Temporarily change Firebase config to use mock services

Let me know what happens when you test email/password authentication!