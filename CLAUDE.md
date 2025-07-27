# Claude Instructions for Kiro Workflow

This project uses **Kiro** for structured project management and development workflow.

## Kiro Project Structure

### Steering Documents (`.kiro/steering/`)
Read these first to understand the project:
- `product.md` - Product overview, features, and user flows
- `tech.md` - Technology stack, dependencies, and build commands  
- `structure.md` - Project architecture, file organization, and patterns

### Specifications (`.kiro/specs/`)
Each feature/module has its own spec folder with:
- `requirements.md` - Functional and non-functional requirements
- `design.md` - Technical design and implementation approach
- `tasks.md` - Implementation checklist with progress tracking

### Hooks (`.kiro/hooks/`)
- `flutter-code-quality.kiro.hook` - Automated code quality checks

## Kiro Workflow

### 1. Understanding Requirements
- **Always read** the relevant `requirements.md` first
- Understand both functional requirements (what the feature does) and non-functional requirements (performance, quality standards)
- Requirements are numbered for traceability (e.g., "1.1", "2.3")

### 2. Review Technical Design  
- Read `design.md` to understand the technical approach
- Understand architecture decisions and implementation patterns
- Note any dependencies or prerequisites

### 3. Follow Task Implementation
- Use `tasks.md` as your implementation guide
- Tasks are organized hierarchically and reference requirements
- Update task status: `[ ]` pending → `[x]` completed → `[-]` not applicable
- Each task includes requirement references (e.g., "_Requirements: 1.1, 2.3_")

### 4. Code Quality Standards
- Run `flutter analyze --fatal-infos --fatal-warnings` (no warnings/info allowed)
- Run `dart format .` for consistent formatting
- Write unit tests for all new code
- Follow existing architecture patterns from `structure.md`

### 5. Pre-Commit Validation
**CRITICAL**: Before any commit, ensure all static checks pass:
```bash
# 1. Format code
dart format .

# 2. Static analysis (must pass with zero issues)
flutter analyze --fatal-infos --fatal-warnings

# 3. Run all tests
flutter test
```
- **Never commit** if any static analysis warnings or errors exist
- **Never commit** if any tests are failing
- Address all issues before proceeding with commit

### 6. Check-in Process
**When human asks for check-in:**
- **Review ALL uncommitted files** using `git status` and `git diff`
- **Confirm with human** if any files are unrelated to the current session's changes
- **Mandatory quality verification**: Ensure all three commands pass with zero issues:
  - `dart format .` - All files properly formatted
  - `flutter analyze --fatal-infos --fatal-warnings` - Zero errors/warnings/info
  - `flutter test` - All tests passing
- **If quality issues exist but are unrelated to your changes**: Confirm with human before proceeding
- **Only commit files relevant to the current work session**

## Working with Kiro Files

### Reading Specifications
```bash
# Always start with steering documents
cat .kiro/steering/product.md
cat .kiro/steering/tech.md  
cat .kiro/steering/structure.md

# Then read the specific feature spec
cat .kiro/specs/[feature-name]/requirements.md
cat .kiro/specs/[feature-name]/design.md
cat .kiro/specs/[feature-name]/tasks.md
```

### Updating Task Progress
When completing tasks, update the markdown checkboxes:
- `- [ ]` = Pending
- `- [x]` = Completed  
- `- [-]` = Not applicable/cancelled

### Tasks.md Formatting Rules
**CRITICAL**: All `tasks.md` files must follow this exact format:

```markdown
# Implementation Plan

- [x] 1. Main task title
  - [x] 1.1 Sub-task with hierarchical numbering
    - Detailed description or sub-points
    - Implementation notes
    - _Requirements: 1.1, 2.3_
  
  - [x] 1.2 Another sub-task
    - Sub-task description and details
    - Multiple bullet points allowed
    - _Requirements: 1.2, 3.1_

- [ ] 2. Next main task
  - [x] 2.1 Sub-task under main task
    - Task description
    - _Requirements: 4_
```

**Formatting Requirements:**
- Start with `# Implementation Plan` header only
- Remove any "Current Status" or other sections
- Main tasks use hierarchical numbering: `1`, `2`, `3`, etc.
- Sub-tasks are nested under main tasks: `1.1`, `1.2`, `2.1`, etc.
- Sub-tasks are indented with 2 spaces under main tasks
- Sub-task details are indented with 4 spaces (2 more than sub-task)
- Each task/sub-task ends with `_Requirements: X, Y, Z_` on its own line
- Use proper checkbox format: `- [x]` completed, `- [ ]` pending, `- [-]` not applicable

**Task Status Management:**
- **Mark completed immediately**: Update `- [ ]` to `- [x]` as soon as task is finished and tested
- **Real-time updates**: Don't batch status changes - update during development
- **Completion criteria**: Only mark `[x]` when ALL sub-requirements are satisfied:
  - Code implementation complete
  - Tests written and passing
  - Static analysis passes
  - Requirements fully addressed
- **Version control**: Commit `tasks.md` changes to track development progress
- **Sub-task tracking**: Mark individual sub-tasks complete as they're finished, not just main tasks

### Requirements.md Formatting Rules
**CRITICAL**: All `requirements.md` files must follow this exact format:

```markdown
# Requirements Document

## Introduction

This document captures the requirements for the [Feature Name] system ([project-abbreviation]). [Brief description of the feature/system and its purpose]. [Optional: Architecture approach mention].

## Requirements

### Requirement 1

**User Story:** As a [user type], I want to [action/goal], so that I can [benefit/outcome].

#### Acceptance Criteria

1. WHEN [condition] THEN the system SHALL [expected behavior]
2. WHEN [condition] THEN the system SHALL [expected behavior]
3. WHEN [condition] THEN the system SHALL [expected behavior]
[Continue numbering as needed]

### Requirement 2

**User Story:** As a [user type], I want to [action/goal], so that I can [benefit/outcome].

#### Acceptance Criteria

1. WHEN [condition] THEN the system SHALL [expected behavior]
2. WHEN [condition] THEN the system SHALL [expected behavior]
[Continue with additional criteria]
```

**Formatting Requirements:**
- Start with `# Requirements Document` header
- Include `## Introduction` section with feature context and purpose
- Use `## Requirements` section for all requirements
- Number requirements sequentially: `### Requirement 1`, `### Requirement 2`, etc.
- Each requirement must have a **User Story** in the format: "As a [user type], I want to [action], so that [benefit]"
- Each requirement must have **Acceptance Criteria** as numbered list
- Use "WHEN...THEN the system SHALL..." format for acceptance criteria
- Use "SHALL" for mandatory requirements (RFC 2119 compliance)
- Requirements should be atomic, testable, and traceable
- Each requirement should focus on a single user goal or system behavior

### Key Principles
1. **Requirements-Driven**: Every implementation should trace back to a requirement
2. **Progressive Implementation**: Follow task order, complete prerequisites first
3. **Quality Gates**: Code quality checks must pass before considering tasks complete
4. **Self-Contained Modules**: Follow modular architecture patterns
5. **Test Coverage**: Write tests as you implement, not after

## Development Commands

### Code Generation & Quality
```bash
# Generate code (DI, GraphQL, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Quality checks (must pass)
flutter analyze --fatal-infos --fatal-warnings
dart format .
flutter test
```

### Common Kiro Tasks
- Update task status in `tasks.md` files
- Reference requirements when implementing features
- Follow architecture patterns from steering documents
- Ensure all quality checks pass before marking tasks complete