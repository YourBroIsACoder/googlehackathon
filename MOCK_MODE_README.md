# Mock Mode - Testing Without Firebase

The app is currently configured to run in **MOCK MODE** - meaning it uses local mock data instead of Firebase. This allows you to test the app without setting up Firebase first.

## What's Mocked

✅ **Authentication**: Mock auth service accepts any email/password
- Email containing "admin" → Admin user
- Other emails → Regular citizen user

✅ **Complaints**: Mock complaint service with sample data
- Pre-loaded with 3 sample complaints
- All CRUD operations work locally
- Data persists during app session

❌ **Image Upload**: Disabled (requires Firebase Storage)
❌ **Google Maps**: Disabled (requires API key)

## How to Use

1. **Run the app**:
   ```bash
   flutter run
   ```

2. **Login/Register**:
   - Use any email/password (e.g., `test@example.com` / `password123`)
   - For admin access: use email containing "admin" (e.g., `admin@test.com`)

3. **Test Features**:
   - Submit complaints (without image upload)
   - View complaints
   - Update status (admin)
   - Set priority (admin)

## Sample Mock Data

The app comes with 3 pre-loaded complaints:
1. **Pothole** (Open, High Priority)
2. **Broken Streetlight** (In Progress, Medium Priority)
3. **Garbage** (Resolved, Medium Priority)

## Enabling Firebase

When you're ready to use Firebase:

1. **Update `lib/main.dart`**:
   - Uncomment Firebase import
   - Uncomment Firebase initialization

2. **Update `lib/providers/auth_provider.dart`**:
   - Change import from `auth_service_mock.dart` to `auth_service.dart`

3. **Update all screens**:
   - Change imports from `complaint_service_mock.dart` to `complaint_service.dart`
   - Files to update:
     - `lib/screens/citizen/my_complaints_screen.dart`
     - `lib/screens/citizen/submit_complaint_screen.dart`
     - `lib/screens/admin/admin_complaints_screen.dart`
     - `lib/screens/admin/complaint_detail_screen.dart`

4. **Update `web/index.html`**:
   - Uncomment Firebase SDK scripts
   - Add your Firebase config

5. **Follow `FIREBASE_SETUP.md`** for complete setup instructions

## Files Using Mock Services

- `lib/services/auth_service_mock.dart` - Mock authentication
- `lib/services/complaint_service_mock.dart` - Mock complaint storage

These will be replaced with Firebase services when you enable Firebase.

## Limitations in Mock Mode

- ❌ No persistent storage (data resets on app restart)
- ❌ No image uploads
- ❌ No Google Maps
- ❌ No real-time sync across devices
- ❌ No user management

But you can test all UI flows and functionality!





