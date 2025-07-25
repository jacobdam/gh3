# Design Document

## Overview

The User Details Screen will be enhanced to provide a comprehensive GitHub user profile view with improved navigation and additional user statistics. The screen will follow the existing modular architecture pattern while extending the current basic implementation to include status messages, navigation tiles, and enhanced user information display.

## Architecture

### Screen Structure
The screen will use a `CustomScrollView` with a `SliverAppBar` to achieve the sticky title behavior:
- **Flexible Header**: Contains avatar, display name, and username with parallax scrolling
- **Sticky Title**: Shows only username when scrolled
- **Body Content**: Scrollable content with user information and navigation tiles

### Component Hierarchy
```
UserDetailsScreen (StatefulWidget)
├── CustomScrollView
│   ├── SliverAppBar (flexible header + sticky title)
│   │   ├── FlexibleSpaceBar (avatar, name, username)
│   │   └── Title (sticky username)
│   └── SliverList
│       ├── UserStatusCard (if status exists)
│       ├── UserInfoSection (bio, company, location)
│       ├── UserStatsRow (followers, following)
│       ├── ListTile (Repositories)
│       ├── ListTile (Starred)
│       └── ListTile (Organizations)
```

## Components and Interfaces

### Enhanced ViewModel
The existing `UserDetailsViewModel` will be extended to support additional GraphQL queries:

```dart
class UserDetailsViewModel extends DisposableViewModel {
  // Existing properties
  String get login;
  GGetUserDetailsData_user? get user;
  
  // New properties for enhanced functionality
  String? get status;
  String? get statusEmoji;
  int get starredRepositoriesCount;
  int get organizationsCount;
  
  // Data accessors for navigation counts
  int get repositoriesCount;
  int get starredRepositoriesCount;
  int get organizationsCount;
}
```

### New UI Components

#### UserStatusCard
```dart
class UserStatusCard extends StatelessWidget {
  final String? status;
  final String? emoji;
  
  // Factory constructor for GraphQL integration
  factory UserStatusCard.fromFragment(GUserStatusFragment fragment);
}
```

#### Navigation ListTiles
Standard Flutter `ListTile` widgets will be used for navigation with:
- Title text (e.g., "Repositories")
- Trailing count display
- Leading icon
- GoRouter navigation on tap (placeholder destinations)

#### UserStatsRow
```dart
class UserStatsRow extends StatelessWidget {
  final int followerCount;
  final int followingCount;
  final VoidCallback? onFollowersPressed;
  final VoidCallback? onFollowingPressed;
}
```

## Data Models

### Enhanced GraphQL Queries

#### Extended User Details Query
```graphql
query GetUserDetails($login: String!) {
  user(login: $login) {
    ...UserProfileFragment
    status {
      message
      emoji
    }
    starredRepositories {
      totalCount
    }
    organizations {
      totalCount
    }
  }
}
```

#### User Status Fragment
```graphql
fragment UserStatusFragment on User {
  status {
    message
    emoji
    createdAt
  }
}
```

### Data Flow
1. **Screen Initialization**: ViewModel fetches user data via GraphQL
2. **Data Processing**: Raw GraphQL data is exposed through ViewModel getters
3. **UI Rendering**: Components use factory constructors to convert GraphQL fragments to UI data
4. **Navigation**: Tapping ListTiles triggers GoRouter navigation to placeholder routes

## Error Handling

### Error States
- **User Not Found**: Display centered message with retry button
- **Network Error**: Show error banner with retry option
- **Partial Data**: Gracefully hide missing sections (status, bio, etc.)
- **Loading State**: Show skeleton loading for different sections

### Error Recovery
```dart
class UserDetailsViewModel {
  String? get error; // Existing error handling
  bool get isUserNotFound; // New: specific check for 404
  void retry(); // Existing retry mechanism
  void clearError(); // Existing error clearing
}
```

## Testing Strategy

### Unit Tests
- **ViewModel Tests**: Test data fetching, error handling, and navigation methods
- **Component Tests**: Test individual UI components with mock data
- **GraphQL Tests**: Test query structure and fragment mapping

### Widget Tests
- **Screen Tests**: Test complete screen rendering with different data states
- **Navigation Tests**: Test navigation tile interactions
- **Error State Tests**: Test error display and retry functionality

### Integration Tests
- **End-to-End Flow**: Test complete user details screen flow
- **Navigation Integration**: Test navigation between user details and other screens
- **GraphQL Integration**: Test real GraphQL queries with test data

## Implementation Phases

### Phase 1: Enhanced UI Structure
- Implement `CustomScrollView` with `SliverAppBar`
- Create sticky title behavior
- Update screen layout to match design requirements

### Phase 2: Status and Additional Data
- Extend GraphQL queries for status, starred repos, and organizations
- Implement `UserStatusCard` component
- Add status display logic to ViewModel

### Phase 3: Navigation ListTiles
- Implement standard `ListTile` widgets for navigation
- Add GoRouter navigation with placeholder routes
- Wire up count displays from ViewModel data

### Phase 4: Enhanced User Stats
- Implement `UserStatsRow` component
- Add interactive follower/following counts
- Integrate with existing user profile data

### Phase 5: Error Handling and Polish
- Implement comprehensive error states
- Add loading skeletons
- Performance optimization and testing

## Performance Considerations

### Optimization Strategies
- **Image Caching**: Use Flutter's built-in image caching for avatars
- **GraphQL Caching**: Leverage Ferry's caching for user data
- **Lazy Loading**: Only load additional data when needed
- **Memory Management**: Proper disposal of subscriptions and resources

### Resource Management
```dart
@override
void onDispose() {
  _userSubscription?.cancel();
  _statusSubscription?.cancel();
  _organizationsSubscription?.cancel();
  // Clear all cached data
}
```

## Accessibility

### Screen Reader Support
- Proper semantic labels for all interactive elements
- Meaningful descriptions for user statistics
- Navigation announcements for screen transitions

### Visual Accessibility
- High contrast support for user information
- Scalable text for all content
- Touch target sizing for navigation tiles

## Future Enhancements

### Planned Features (Not in Current Scope)
- **Pinned Repositories**: Display user's pinned repositories
- **README Profile**: Show user's profile README content
- **Activity Timeline**: Display recent user activity
- **Social Features**: Follow/unfollow functionality