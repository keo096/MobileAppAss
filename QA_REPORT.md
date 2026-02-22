# QA & Testing Report - Smart Quiz App

**Role:** QA & Documentation Lead
**Project:** Mobile App Assignment

## 1. Functional Testing (Manual)

| Module | Test Flow | Status | Notes |
| :--- | :--- | :--- | :--- |
| **Authentication** | Login with `admin` / `admin123` | ✅ **Pass** | Fallback logic works stably. Role correctly set to Admin. |
| **Authentication** | Login with `user` / `user123` | ✅ **Pass** | Fallback logic works stably. Role correctly set to User. |
| **Authentication** | Login with random values (e.g., `a` / `1`) | ✅ **Pass** | **Fixed**: Correctly rejects and shows error. |
| **Authentication** | Login with empty fields | ✅ **Pass** | Local validation prevents login and shows field errors. |
| **Authentication** | Logout functionality | ✅ **Pass** | Correctly clears navigation stack and returns to Login. |
| **Home Screen** | Category & Daily Challenge Display | ✅ **Pass** | Banner carousel and category icons render correctly. |
| **Category Details** | Topic Filtering | ✅ **Pass** | Filter chips correctly update the quiz list. |
| **Role Visibility** | Admin "Manage" vs User "Start" | ✅ **Pass** | Buttons change dynamically based on the logged-in user role. |
| **Profile** | Statistics Calculation | ✅ **Pass** | Grade (A/B/C/D/F) and Time Spent format correctly. |

## 2. Documented Bugs & Fixes

### Bug #1: Statistics Card Layout Assertion
- **Description:** A persistent assertion error "Cannot hit test a render box..." occurred in the Profile Page.
- **Root Cause:** Deeply nested `Expanded` widgets were used without direct `Row`/`Column` parents during rebuilds.
- **Fix:** Refactored the statistics layout to move `Expanded` out of helper methods into direct children of stable `Row` widgets.

### Bug #2: RenderFlex Overflow (2.5 - 5 Pixels)
- **Description:** A minor vertical overflow occurred at the bottom of pages on some devices.
- **Root Cause:** A fixed `height: 70` in `BottomNavBar` conflicted with the `SafeArea` and `extendBody: true` logic.
- **Fix:** Standardized `BottomNavBar` height to `80px`, removed `extendBody: true`, and enabled proper `SafeArea` docking.

### Bug #3: Static User Profiles
- **Description:** The profile page was displaying hardcoded guest data regardless of the logged-in user.
- **Root Cause:** Missing integration between `ProfileProvider` and the UI.
- **Fix:** Integrated `ProfileProvider` with `AuthProvider`. Profile now reflects actual user XP, Rank, and dynamic grades.

### Bug #4: Permissive Login (Security Flaw)
- **Description:** Any username/password combination (e.g., "a" / "1") allowed login access.
- **Root Cause:** The remote Postman mock API was too permissive, returning 200 OK for any authentication request.
- **Fix:** Implemented strict credential enforcement in `RemoteAuthService`. The app now strictly validates against predefined accounts (`admin`/`admin123`, `user`/`user123`) and rejects non-matching input.

## 3. Automated Testing

### Unit Test: Authentication & User Model
- **File:** `test/auth_unit_test.dart`
- **Result:** all 5 tests passed successfully.

---
*Prepared for Teacher Review - Smart Quiz Project*
