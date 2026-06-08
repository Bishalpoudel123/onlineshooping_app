# Firebase Authentication & Firestore Setup Guide

## Issues Fixed

### 1. **Firestore Data Not Being Stored (CRITICAL)**
**Root Cause:** Default Firestore security rules deny all read/write operations

**Solution:** Apply the Firestore security rules from `firestore.rules` file to your Firebase console:
- Go to Firebase Console → Your Project → Firestore → Rules
- Copy all content from `firestore.rules` file
- Paste into the Firebase Rules editor
- Click "Publish"

### 2. **Signup Refactored to Use AuthService**
- Signup screen now uses the centralized `AuthService.signUp()` method
- Consistent with login implementation
- Better error handling and logging

### 3. **Improved Error Handling**
- Better error messages for all authentication scenarios
- Added logging for debugging (check console output)
- Non-blocking email service (won't delay login)

### 4. **Firestore Data Structure**
Users collection now stores:
```
/users/{uid}
  ├─ uid: string
  ├─ name: string
  ├─ email: string
  ├─ phone: string
  ├─ createdAt: timestamp
  └─ updatedAt: timestamp
```

## Setup Checklist

### Step 1: Firebase Console Configuration
- [ ] Go to [Firebase Console](https://console.firebase.google.com)
- [ ] Select your project "ecommerance-54dc8"
- [ ] Navigate to **Firestore Database**
- [ ] Click on **Rules** tab
- [ ] Delete existing rules and paste the content from `firestore.rules`
- [ ] Click **Publish**

### Step 2: Verify Configuration
- [ ] Check Android google-services.json is present (✓ Already configured)
- [ ] Verify Firebase initialization in main.dart (✓ Already configured)
- [ ] Check pubspec.yaml has required packages (✓ Already configured)

### Step 3: Testing
1. **Signup Test:**
   - Run the app
   - Open signup screen
   - Fill in all fields with valid data
   - Check console logs for "[AuthService]" messages
   - Verify user appears in Firebase Auth console
   - Verify user data appears in Firestore

2. **Login Test:**
   - Use created account credentials
   - Check console for "[AuthService] Login successful"
   - Verify welcome email sent (check console for "[EmailService]" messages)

3. **Firestore Test:**
   - Go to Firebase Console → Firestore
   - Navigate to collections → users
   - Should see document with uid as name
   - Should contain name, email, phone, createdAt fields

## Console Logging

The app now logs important events:
- `[AuthService]` - Authentication events
- `[EmailService]` - Email sending events

**How to view logs:**
- Flutter Console in VS Code
- Android Logcat (Android Studio)
- Xcode console (iOS)

## Common Issues

### Issue: "Permission denied" error
**Solution:** Firestore rules not updated. Follow Step 1 again.

### Issue: User created in Auth but not in Firestore
**Solution:** Check firestore.rules are correctly published. Verify user UID matches in rules.

### Issue: App crashes on signup
**Solution:** Check console logs starting with "[AuthService]". The error message will indicate the issue.

### Issue: Email not sending
**Solution:** Check console for "[EmailService]" logs. Email service doesn't block signup - it's background only.

## Files Modified

1. **lib/screens/signup.dart** - Refactored to use AuthService
2. **lib/screens/login.dart** - Added non-blocking email service
3. **lib/servies/auth_servies.dart** - Enhanced with logging and error handling
4. **lib/servies/email_servies.dart** - Added better error handling and timeout
5. **firestore.rules** - NEW: Security rules file

## Next Steps

- [ ] Deploy Firestore rules
- [ ] Test signup and login flow
- [ ] Monitor console logs for any issues
- [ ] Verify data in Firebase Console
- [ ] Test all authentication scenarios

---

**Note:** After deploying Firestore rules, new signups should automatically save user data to Firestore.
