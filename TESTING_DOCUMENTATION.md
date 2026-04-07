# Testing & Debugging Documentation — Adaptiva Streaming Platform

---

## STEP 1: Test Case Document

| TC ID | Scenario | Steps | Expected Result | Actual Result | Status |
|-------|----------|-------|-----------------|---------------|--------|
| TC01 | Login with valid credentials | 1. Open app → Sign In screen 2. Enter valid email & password 3. Tap "Sign In" | User is authenticated, navigated to Home screen, session is saved | User navigated to Home screen successfully, session persisted on restart | **Pass** |
| TC02 | Login with wrong password | 1. Open app → Sign In screen 2. Enter valid email but incorrect password 3. Tap "Sign In" | Error snackbar: "Incorrect password. Please try again." | Error snackbar displayed with correct message | **Pass** |
| TC03 | Registration with new user | 1. Open app → Sign In → Tap "Create Account" 2. Fill name, email, password 3. Tap "Sign Up" | New user created in Firebase Auth + Firestore, redirected to Home | User registered and redirected to Home; Firestore `users/{uid}` document created | **Pass** |
| TC04 | Admin video upload (CRUD – Create) | 1. Login as admin 2. Tap FAB "Upload Video" 3. Fill title, description, category, URLs 4. Tap "Upload Video" | Video document added to Firestore `videos` collection, success snackbar shown, local notification fired | Video added, snackbar shown, notification "New Video Added 🎬" appeared | **Pass** |
| TC05 | Admin video delete (CRUD – Delete) | 1. Login as admin 2. Long-press/tap delete icon on a video card 3. Confirm deletion in dialog | Video removed from Firestore, category `videoCount` decremented, video removed from list | Video deleted from Firestore and UI list updated | **Pass** |
| TC06 | Bottom navigation | 1. From Home, tap "Categories" tab 2. Tap "Settings" tab 3. Tap "Profile" tab 4. Tap "Home" tab | Each tap navigates to the correct screen; selected tab is highlighted | All navigations work correctly | **Pass** |
| TC07 | Video playback & watch history (API/Data) | 1. Login as user 2. Tap any video card on Home 3. Video player screen opens 4. Video starts playing 5. Go to Profile → Watched Videos | Video plays from network URL, watch history entry created in Firestore `users/{uid}/watch_history/{videoId}` | Video played, watch history recorded and visible on Profile | **Pass** |
| TC08 | Session persistence | 1. Login successfully 2. Close the app completely 3. Reopen the app | User remains signed in; Home screen is shown directly (not Sign In) | Session restored from SharedPreferences; Home displayed | **Pass** |
| TC09 | Instant local notification | 1. Login → Navigate to Settings 2. Scroll to Notifications section 3. Tap "Send Test Notification" | Local notification appears with title "Test Notification 🔔" and body text | Notification appeared in system tray | **Pass** |
| TC10 | Scheduled notification | 1. Login → Settings → Notifications 2. Tap "Schedule Reminder (10 sec)" 3. Wait 10 seconds | Notification "Scheduled Reminder ⏰" appears after 10 seconds | Notification appeared after ~10 seconds | **Pass** |

---

## STEP 2: Functional Testing

### Authentication Testing

| Test | Method | Result |
|------|--------|--------|
| Login with valid email/password | `AuthService.signIn()` via Firebase Auth | ✅ Pass |
| Login with unregistered email | Enter non-existent email | ✅ Error: "User not found" |
| Login with empty fields | Leave email/password blank | ✅ Form validation prevents submit |
| Registration with duplicate email | Register with existing email | ✅ Error: "This email is already registered" |
| Registration with weak password | Password < 6 chars | ✅ Error: "Password is too weak" |
| Sign out | Tap logout from Settings or Profile | ✅ Session cleared, redirected to Sign In |

### CRUD Testing

| Test | Method | Result |
|------|--------|--------|
| **Create** – Upload video (Admin) | `DatabaseService.addVideo()` | ✅ Document created in `videos` collection |
| **Read** – Load all videos | `DatabaseService.getVideos()` | ✅ Videos fetched and displayed on Home |
| **Read** – Load categories | `DatabaseService.getCategories()` | ✅ Categories displayed on Categories screen |
| **Update** – Edit video (Admin) | `DatabaseService.updateVideo()` via Admin Edit screen | ✅ Video fields updated in Firestore |
| **Delete** – Delete video (Admin) | `DatabaseService.deleteVideo()` with confirmation dialog | ✅ Video removed, `videoCount` decremented |

### API / Data Retrieval Testing

| Test | Method | Result |
|------|--------|--------|
| Fetch videos from Firestore | `_firestore.collection('videos').orderBy('createdAt').get()` | ✅ Pass |
| Fetch watch history | `_firestore.collection('users/{uid}/watch_history').get()` | ✅ Pass |
| No internet handling | `Connectivity().checkConnectivity()` | ✅ "No internet connection" error state shown |
| Video stream from S3 URL | `VideoPlayerController.networkUrl()` | ✅ Pass (URL encoding `+` → `%20` applied) |

### Navigation Testing

| Test | Method | Result |
|------|--------|--------|
| Home → Categories | BottomNavigationBar index 1 | ✅ Pass |
| Home → Settings | BottomNavigationBar index 2 | ✅ Pass |
| Home → Profile | BottomNavigationBar index 3 | ✅ Pass |
| Home → Video Player | Tap video card | ✅ Pass |
| Sign In → Sign Up | Tap "Create Account" link | ✅ Pass |
| Admin: Home → Upload | Tap FAB | ✅ Pass |

### Session Management Testing

| Test | Method | Result |
|------|--------|--------|
| Session saved on login | `SharedPreferences.setString('current_user', ...)` | ✅ Pass |
| Session restored on app restart | `_restoreSession()` in `AuthService.initialize()` | ✅ Pass |
| Session cleared on logout | `SharedPreferences.remove()` for all session keys | ✅ Pass |

---

## STEP 3: UI/UX Testing

| Check | Criteria | Status |
|-------|----------|--------|
| **Alignment** | All text, cards, and buttons are properly centered/aligned | ✅ Pass |
| **Colors & Spacing** | Theme colors from `AppTheme` used consistently; no hardcoded colors | ✅ Pass |
| **Font Readability** | `AppTheme` text styles (headlineLarge, bodyMedium, etc.) provide clear hierarchy | ✅ Pass |
| **Button Accessibility** | All buttons have visible labels, icons, and proper tap targets (min 48dp) | ✅ Pass |
| **Layout Consistency** | Card layouts, padding (`AppConstants.spacingLarge`), and border radii are uniform | ✅ Pass |
| **Loading States** | `CircularProgressIndicator` shown during data fetches | ✅ Pass |
| **Error States** | Dedicated error widgets with retry buttons for network and fetch failures | ✅ Pass |
| **Empty States** | "No videos available" and "No videos watched yet" placeholder screens | ✅ Pass |
| **Responsive Design** | `isMobile` breakpoint adjusts padding on Sign In/Sign Up screens | ✅ Pass |
| **Animations** | Fade + slide animations on Sign In screen for smooth entry | ✅ Pass |

---

## STEP 4: Debugging Using Tools

### Debugging Techniques Used

| Tool / Technique | Usage | Example |
|-----------------|-------|---------|
| `print()` logs | Auth flow tracing | `print('=== SIGN IN START ===');` in `auth_service.dart` |
| `debugPrint()` | Notification debugging | `debugPrint('FCM Token: $token');` in `notification_service.dart` |
| Try/Catch blocks | All service methods | Every Firestore call wrapped in try/catch with specific exception types |
| `mounted` checks | Prevent setState after dispose | `if (mounted) { setState(() => ...); }` in all async callbacks |
| Flutter DevTools | Widget Inspector for layout | Used to inspect widget tree and identify overflow issues |
| Android Logcat | Native crash analysis | Used to debug Gradle build failures and FCM service worker errors |

### Common Issues Debugged

| Issue | Cause | Fix Applied |
|-------|-------|-------------|
| **Null pointer on video tap** | `_authService.currentUser` may be null | Added null check: `if (user != null)` before navigation |
| **API failure – videos not loading** | S3 URLs with `+` character not encoded | Applied `videoUrl.replaceAll('+', '%20')` |
| **UI overflow on video description** | Long text without constraints | Added `maxLines: 2, overflow: TextOverflow.ellipsis` |
| **Navigation stack issues on logout** | Old routes remained in stack | Used `pushAndRemoveUntil((route) => false)` to clear stack |
| **Core library desugaring error** | `flutter_local_notifications` requires Java 8+ APIs | Enabled `isCoreLibraryDesugaringEnabled = true` in `build.gradle.kts` |
| **FCM service worker error on web** | Missing `firebase-messaging-sw.js` | Noted as web-only limitation; works correctly on Android |

---

## STEP 5: Bug Report

| Bug ID | Description | Steps to Reproduce | Severity | Fix Status |
|--------|-------------|---------------------|----------|------------|
| BUG-01 | **Core library desugaring build failure** — `flutter_local_notifications` plugin fails to build on Android | 1. Add `flutter_local_notifications: ^18.0.1` to pubspec 2. Run `flutter run` on Android | **High** | ✅ Resolved — Added `isCoreLibraryDesugaringEnabled = true` and `coreLibraryDesugaring` dependency in `build.gradle.kts` |
| BUG-02 | **Missing `uiLocalNotificationDateInterpretation` parameter** — `zonedSchedule()` compile error | 1. Call `NotificationService.scheduleNotification()` 2. Build fails at `zonedSchedule()` | **High** | ✅ Resolved — Added required `uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime` parameter |
| BUG-03 | **S3 thumbnail/video URLs failing with `+` characters** — Images and videos not loading when filename has spaces | 1. Upload video with spaces in filename 2. Thumbnail shows error icon, video fails to play | **High** | ✅ Resolved — Applied `.replaceAll('+', '%20')` on all S3 URLs in `home.dart` and `video_player_screen.dart` |
| BUG-04 | **FCM service worker registration fails on Chrome (web)** — `firebase-messaging-sw.js` returns HTML MIME type | 1. Run app on Chrome via `flutter run` 2. FCM initialization throws service worker error | **Medium** | ⚠️ Open — Web platform limitation; FCM push works correctly on Android. For web, a `firebase-messaging-sw.js` file must be added to the `web/` directory |
| BUG-05 | **setState called after dispose on video list refresh** — Navigating away from Home while videos are loading causes error | 1. Open Home screen 2. Immediately navigate to another tab before videos finish loading | **Medium** | ✅ Resolved — Added `if (mounted)` guard before all `setState()` calls in async callbacks |
| BUG-06 | **Edit Profile button non-functional** — Tapping "Edit Profile" on Profile screen only shows a snackbar | 1. Navigate to Profile 2. Tap "Edit Profile" button | **Low** | ⚠️ Open — Feature placeholder; shows "Edit profile feature coming soon!" snackbar |
| BUG-07 | **Forgot Password not implemented** — Tapping "Forgot Password?" on Sign In screen only shows a snackbar | 1. Open Sign In 2. Tap "Forgot Password?" | **Low** | ⚠️ Open — Feature placeholder; shows "Forgot password feature coming soon!" snackbar |

---

## STEP 6: Re-Test After Fixes

| Bug ID | Original Issue | Fix Applied | Re-Test Result | Status |
|--------|---------------|-------------|----------------|--------|
| BUG-01 | Desugaring build failure | Added `isCoreLibraryDesugaringEnabled = true` + desugar dependency | Build succeeds, app runs on emulator | ✅ **Resolved** |
| BUG-02 | Missing `zonedSchedule` parameter | Added `uiLocalNotificationDateInterpretation` | Scheduled notification fires after 10 seconds | ✅ **Resolved** |
| BUG-03 | S3 URLs with `+` not loading | `replaceAll('+', '%20')` on all URLs | Thumbnails and videos load correctly | ✅ **Resolved** |
| BUG-04 | FCM web service worker error | N/A (web limitation) | Works on Android; web requires additional setup | ⚠️ **Open** |
| BUG-05 | setState after dispose | `if (mounted)` guards added | No errors when navigating quickly | ✅ **Resolved** |
| BUG-06 | Edit Profile placeholder | N/A (feature not yet implemented) | — | ⚠️ **Open** |
| BUG-07 | Forgot Password placeholder | N/A (feature not yet implemented) | — | ⚠️ **Open** |

---

## Summary

- **Total Test Cases:** 10
- **Passed:** 10 / 10
- **Total Bugs Found:** 7
- **Resolved:** 4 / 7
- **Open (non-critical):** 3 (1 Medium — web FCM, 2 Low — feature placeholders)
