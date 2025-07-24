---
inclusion: always
---

# Kiro Lessons Learned

Quick reference for common issues and their solutions when working with Kiro.

## Git Commands Hang in Terminal

**Problem:** Git commands like `git diff` hang because they use interactive pager (less)

**Solution:** Use `--no-pager` flag to bypass pager entirely

**Command:** `git --no-pager diff`

## Flutter Build Runner Deprecated Command

**Problem:** `flutter packages pub run build_runner` shows deprecation warning

**Solution:** Use `dart run build_runner` instead

**Command:** `dart run build_runner build --delete-conflicting-outputs`

## Missing Generated Files in Ferry/GraphQL Commits

**Problem:** After running `flutter packages pub run build_runner build` or `dart run build_runner build`, some generated files may be missed when staging commits, particularly Ferry serializer files.

**Solution:** Always check for and include ALL generated files when committing GraphQL/Ferry changes

**Critical Files to Check:**
- `lib/__generated__/serializers.gql.dart` - Ferry serialization registry
- `lib/__generated__/serializers.gql.g.dart` - Built value serializers  
- All `__generated__/*.graphql.dart` files in component directories
- Updated `lib/src/init.config.dart` (Injectable dependency injection config)

**Best Practice:**
1. Run `git status` after build_runner to see ALL modified files
2. Use `git add lib/__generated__/` to stage all generated files at once
3. Double-check that serializer files are included before committing
4. If missed, create immediate follow-up commit with missing files

**Example Commands:**
```bash
# After running build_runner
git status
git add lib/__generated__/  # Stage all generated files
git add lib/src/init.config.dart  # Don't forget Injectable config
git status  # Verify all generated files are staged
```

---

*Add new lessons here as they are discovered*