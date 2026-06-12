# AI Project Rules

## General Rules

- Always use clean architecture.
- Keep code modular and reusable.
- Avoid duplicated code.
- Use meaningful variable and function names.
- Prefer readability over clever code.
- Keep files small and focused.

---

# Project Structure

## Flutter / Dart Structure

```text
lib/
│
├── core/
├── shared/
├── features/
│   ├── auth/
│   ├── flashcard/
│   ├── quiz/
│   └── profile/
│
└── main.dart
Feature Structure

Each feature should contain:

feature_name/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
└── widgets/
Naming Convention
File Names

Use snake_case:

user_profile_screen.dart
auth_service.dart
Class Names

Use PascalCase:

class UserProfile {}
Variables & Functions

Use camelCase:

final userName = "";
void fetchData() {}
UI Rules
Prefer reusable widgets.
Avoid large widget trees in one file.
Extract repeated UI components.
Use const constructors whenever possible.
Keep business logic outside UI.
State Management
Use Provider / Riverpod / Bloc consistently.
Do not mix multiple state management solutions.
Keep UI reactive and simple.
API Rules
All API calls must go through services.
UI should never call HTTP directly.
Use repositories between UI and services.

Example:

UI -> Provider(Use Provider only when state is shared across multiple screens.
Do not create providers by default) -> Repository -> Service -> API
Error Handling
Always handle exceptions.
Show user-friendly error messages.
Avoid empty catch blocks.

Example:

try {

} catch (e) {
  debugPrint(e.toString());
}
Code Style
Follow official Dart formatter.
Maximum line length: 80-100 characters.
Remove unused imports.
Avoid commented dead code.
Performance Rules
Avoid unnecessary rebuilds.
Use lazy loading when possible.
Optimize list rendering.
Cache expensive operations.
Git Rules
Branch Naming
feature/login
feature/flashcard
fix/auth-bug
Commit Style
feat: add login api
fix: resolve null exception
refactor: clean flashcard module
Security Rules
Never hardcode secrets.
Use environment variables.
Validate all external input.
Protect API keys.
Documentation
Write comments only when necessary.
Keep README updated.
Document public APIs and services.
Clean Code Principles
Single Responsibility Principle
DRY (Don't Repeat Yourself)
KISS (Keep It Simple)
Separation of Concerns
AI Coding Instructions
Generate production-ready code.
Prefer scalable architecture.
Avoid deprecated APIs.
Follow latest Flutter/Dart best practices.
Explain important architectural decisions.
Keep consistency across the project.

# Recommended Libraries

## State Management

- flutter_riverpod

## Networking

- dio

## Local Storage

- shared_preferences
- hive 
flutter_secure_storage

## UI & Styling

- google_fonts
- flutter_screenutil
- flutter_animate
- shadcn_ui

## Icons

- font_awesome_flutter
- iconsax_flutter

## Utilities

- intl
- freezed
- json_serializable

---

# Dependency Rules

- Prefer officially maintained packages.
- Avoid outdated or unmaintained libraries.
- Keep dependencies minimal.
- Do not introduce new packages unless necessary.
- Reuse existing packages whenever possible.

---

# Preferred Architecture Stack

```text
Riverpod + Dio + GoRouter + Feature-first structure
```