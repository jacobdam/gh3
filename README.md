# gh3

A GitHub client for mobile built with Flutter.

This project is for testing coding agent ability, using both Kiro and Claude. It is not ad-hoc vibe coding - the author wants to make the work more structured. This is just a hobby and experiment, nothing related to any business, nothing serious in the code.

For detailed project information, see the [steering documents](.kiro/steering/) which contain:
- Product overview and features
- Technology stack and dependencies  
- Project architecture and structure

## Getting Started (For Human Contributors)

```bash
# Install dependencies
flutter pub get

# Generate code (DI, mocks, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Code quality checks
flutter analyze --fatal-infos --fatal-warnings
dart format .
```