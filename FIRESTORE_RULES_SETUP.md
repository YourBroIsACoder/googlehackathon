# Firestore Security Rules Setup

## 🛡️ Security Rules Overview

The app includes comprehensive security rules that ensure:
- **Users can only see their own data**
- **Admins can see and modify all complaints**
- **Authentication is required for all operations**
- **Proper data validation and access control**

## 📋 Apply Security Rules

### Step 1: Copy the Rules
1. Open `firestore.rules` file in your project
2. Copy all the content

### Step 2: Apply in Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `civic-complaint-platform`
3. Go to **Firestore Database**
4. Click on **Rules** tab
5. **Replace all existing rules** with the content from `firestore.rules`
6. Click **Publish**

### Step 3: Verify Rules Are Active
You should see:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // ... rest of the rules
  }
}
```

## 🔒 What These Rules Do

### Users Collection (`/users/{userId}`)
- ✅ Users can read/write their own profile
- ❌ Users cannot access other users' profiles
- ❌ Unauthenticated access denied

### Complaints Collection (`/complaints/{complaintId}`)
- ✅ **Read**: Any authenticated user (for public complaint viewing)
- ✅ **Create**: Users can create complaints (with their own userId)
- ✅ **Update**: Users can update their own complaints, admins can update any
- ✅ **Delete**: Only admins can delete complaints
- ❌ Unauthenticated access denied

### Admin Detection
Rules automatically detect admin users by checking the `isAdmin` field in the user's profile document.

## 🧪 Test Security Rules

### Test User Access
1. Register as a regular user
2. Create a complaint
3. Try to view other users' complaints (should work - public viewing)
4. Try to modify another user's complaint (should fail)

### Test Admin Access
1. Create an admin user (set `isAdmin: true` in Firestore)
2. Login as admin
3. Should be able to view and modify all complaints
4. Should be able to delete complaints

## ⚠️ Important Notes

- **Test Mode**: If you're still in "test mode", these rules will override the test mode
- **Production Ready**: These rules are secure for production use
- **Admin Creation**: You need to manually set `isAdmin: true` for admin users
- **Public Complaints**: All authenticated users can view complaints (by design)

## 🔧 Troubleshooting

### "Permission Denied" Errors
- Ensure user is authenticated
- Check that `isAdmin` field exists for admin users
- Verify rules are published correctly

### Rules Not Working
- Make sure you clicked "Publish" after pasting the rules
- Check the Firebase Console for any rule syntax errors
- Test with a fresh browser session

Apply these rules and your Firestore database will be properly secured! 🛡️