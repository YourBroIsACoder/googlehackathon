# Troubleshooting - Firebase Error Fix

## Error: "No Firebase App '[DEFAULT]' has been created"

If you see this error, it means the app is still trying to use Firebase services. This usually happens when:

1. **Hot Reload Issue**: The app was running when we switched to mock mode
2. **Cached Code**: Old compiled code is still in memory

## Solution: Full Restart Required

**Stop the app completely and restart:**

1. **Stop the running app** (press `q` in terminal or stop button in IDE)
2. **Clean the build**:
   ```bash
   cd civic_complaint_platform
   flutter clean
   flutter pub get
   ```
3. **Restart the app**:
   ```bash
   flutter run
   ```

**DO NOT use hot reload (`r`)** - Use hot restart (`R`) or full restart instead.

## Verify Mock Mode is Active

Check these files to ensure they're using mock services:

1. **`lib/providers/auth_provider.dart`**:
   - Should import `auth_service_mock.dart`
   - Should NOT import `auth_service.dart`

2. **All screen files** should import `complaint_service_mock.dart`, not `complaint_service.dart`

3. **`lib/main.dart`**:
   - Firebase import should be commented out
   - Firebase initialization should be commented out

## If Error Persists

1. **Check for any remaining Firebase imports**:
   ```bash
   grep -r "firebase_auth" lib/
   grep -r "cloud_firestore" lib/
   ```

2. **Verify mock services exist**:
   - `lib/services/auth_service_mock.dart` ✓
   - `lib/services/complaint_service_mock.dart` ✓

3. **Delete build folders**:
   ```bash
   flutter clean
   rm -rf build/
   rm -rf .dart_tool/
   flutter pub get
   flutter run
   ```

## Expected Behavior in Mock Mode

- ✅ App starts without Firebase errors
- ✅ Login/Register works with any credentials
- ✅ No Firebase initialization messages
- ✅ Complaints stored in memory (reset on restart)

## Still Having Issues?

Make sure you've:
1. Stopped the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Started fresh with `flutter run`

The error should be resolved after a full restart!





