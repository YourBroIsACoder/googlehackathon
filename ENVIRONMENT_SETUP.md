# 🔐 Environment Setup Guide

## ⚠️ **IMPORTANT: API Keys Security**

This project requires API keys that should **NOT** be committed to version control for security reasons.

## 🔑 **Required API Keys**

### 1. **Google Gemini API Key**
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create an API key
3. Copy the key

### 2. **Firebase Configuration**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to Project Settings → General → Your apps
4. Copy the web app configuration

## 🛠️ **Setup Instructions**

### **Step 1: Configure AI Service**
Edit `lib/config/ai_config.dart`:
```dart
static const String geminiApiKey = 'YOUR_ACTUAL_GEMINI_API_KEY_HERE';
```

### **Step 2: Configure Firebase**
Edit `lib/config/firebase_config.dart`:
```dart
static const FirebaseOptions webOptions = FirebaseOptions(
  apiKey: "your-actual-firebase-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.firebasestorage.app",
  messagingSenderId: "your-sender-id",
  appId: "your-app-id",
  measurementId: "your-measurement-id"
);
```

## 🚀 **For Production Deployment**

### **Vercel Environment Variables**
Add these in Vercel Dashboard → Settings → Environment Variables:
- `GEMINI_API_KEY` = Your Gemini API key
- `FIREBASE_API_KEY` = Your Firebase API key
- `FIREBASE_PROJECT_ID` = Your Firebase project ID
- `FIREBASE_APP_ID` = Your Firebase app ID

### **Local Development**
Create a `.env` file (already in .gitignore):
```
GEMINI_API_KEY=your_gemini_api_key_here
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_project_id_here
```

## 🔒 **Security Best Practices**

1. **Never commit API keys** to version control
2. **Use environment variables** for production
3. **Regenerate keys** if accidentally exposed
4. **Use different keys** for development and production
5. **Restrict API key usage** in respective consoles

## 🆘 **If Keys Were Exposed**

### **Immediate Actions:**
1. **Regenerate Gemini API Key**:
   - Go to Google AI Studio
   - Delete the exposed key
   - Create a new one

2. **Regenerate Firebase Keys**:
   - Go to Firebase Console
   - Create a new web app
   - Use the new configuration

3. **Update Vercel Environment Variables**:
   - Replace with new keys
   - Redeploy the application

## ✅ **Verification**

After setup, verify everything works:
1. Run `flutter run -d chrome`
2. Test login/registration
3. Test AI assistant
4. Test complaint submission

Your app should work perfectly with the new secure configuration! 🎉