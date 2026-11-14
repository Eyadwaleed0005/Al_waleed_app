# Al-Waleed

Al-Waleed is an educational mobile application for secondary school students, providing grade-based lessons, study materials, exams, results, and live-session links.

## Features

- Student authentication and account information
- Grade-based lessons and educational videos
- PDF study materials
- Online exams, quizzes, and results
- Live-session links
- Push notifications and announcements
- Network connection monitoring
- Optional and forced application updates
- Screenshot and screen-recording protection

## Tech Stack

Flutter, Dart, Firebase Authentication, Cloud Firestore, Firebase Storage, Cloud Functions, Firebase Cloud Messaging, Bloc/Cubit, GetIt, Flutter Secure Storage, and SharedPreferences.

## Architecture

The project follows Clean Architecture, organizing features into:

- **Data:** Data sources and repository implementations
- **Domain:** Entities, repository contracts, and use cases
- **Presentation:** Screens, widgets, and state management

## Platforms

Android and iOS. Current CI/CD distribution workflows target Android.

## CI/CD

GitHub Actions handles checks and builds. Fastlane distributes builds to Firebase App Distribution and Google Play.

| Workflow | Trigger | Result |
| --- | --- | --- |
| Development CI | Pull request to `development` | Static analysis and tests |
| Development Distribution | Manual dispatch on `development` | Shorebird APK sent to Firebase group `team` |
| Main Distribution | Merged PR from `development` to `main` in this repository | Flutter APK sent to Firebase group `client` |
| Google Play Production | Merged PR from `main` to `google-play-production` in this repository | Flutter App Bundle uploaded to Production |

Workflow files are located in `.github/workflows/`. Distribution lanes are defined in `android/fastlane/Fastfile`.

Shorebird patches are supported only by development builds. Client and production builds receive updates through new APKs or Google Play releases.

Each full Shorebird release requires a unique release version. Patches retain their target release version. New Google Play uploads require an unused, higher build number.

Signing credentials and service account keys are stored in GitHub Actions Secrets.

## Development

Developed by **Eyad Waleed**  
© 2026 Fame X. All rights reserved.
