# Implementation Plan

- [x] 1. Extend GraphQL queries for additional user data
  - Update `user_details_viewmodel.graphql` to include status, starred repositories, and organizations counts
  - Add status fragment to support user status messages and emoji
  - Regenerate GraphQL code using build_runner
  - _Requirements: 1.5, 1.6, 2.1, 2.3, 2.5_

- [x] 2. Update UserDetailsViewModel with enhanced data access
  - Add getters for status message, emoji, starred count, and organizations count
  - Extend existing user data exposure to include new GraphQL fields
  - Ensure proper null handling for optional status data
  - _Requirements: 1.5, 1.6, 2.1, 2.3, 2.5_

- [x] 3. Create UserStatusCard component
  - Implement widget with explicit fields for status message and emoji
  - Add factory constructor `fromFragment()` for GraphQL integration
  - Handle empty/null status states gracefully
  - Write unit tests for component with various status scenarios
  - _Requirements: 1.5_

- [x] 4. Implement CustomScrollView with SliverAppBar structure
  - Replace existing Scaffold body with CustomScrollView
  - Create SliverAppBar with flexible header containing avatar, name, and username
  - Implement sticky title behavior showing only username when scrolled
  - Ensure proper back navigation handling
  - _Requirements: 1.1, 1.2, 1.3_

- [x] 5. Create UserStatsRow component for follower/following display
  - Implement widget with explicit fields for follower and following counts
  - Add factory constructor for GraphQL integration
  - Format large numbers appropriately (1.2k, 1.5M format)
  - Include tap handlers for future navigation (placeholder for now)
  - Write unit tests for count formatting and display
  - _Requirements: 1.7, 4.2_

- [x] 6. Implement navigation ListTiles for repositories, starred, and organizations
  - Create three ListTile widgets with appropriate icons and titles
  - Display counts from ViewModel in trailing position
  - Ensure proper count formatting using existing helper methods
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6_

- [ ] 7. Integrate UserProfile widget into new screen layout
  - Modify existing UserProfile widget usage to fit within SliverList
  - Ensure bio, company, and location display properly in new layout
  - Handle cases where user data is missing or null
  - _Requirements: 1.4, 1.6, 3.5_

- [ ] 8. Add UserStatusCard to screen layout
  - Integrate UserStatusCard component into SliverList
  - Show status card only when user has a status message
  - Position status card appropriately in the content flow
  - _Requirements: 1.5, 3.5_

- [ ] 9. Implement comprehensive error handling
  - Add specific handling for user not found (404) errors
  - Create user-friendly error messages for different failure scenarios
  - Implement retry functionality for failed requests
  - Add loading states for different sections of the screen
  - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 10. Add loading skeleton and performance optimizations
  - Implement skeleton loading states for user data sections
  - Ensure proper image caching for user avatars
  - Optimize GraphQL query performance and caching
  - Verify proper resource disposal in ViewModel
  - _Requirements: 4.1, 4.3, 4.5_

- [ ] 11. Write comprehensive tests for enhanced screen
  - Create widget tests for new CustomScrollView layout
  - Test navigation ListTile interactions and routing
  - Test error states and loading scenarios
  - Test UserStatusCard display with various status data
  - Write integration tests for complete user details flow
  - _Requirements: All requirements validation through testing_

- [ ] 12. Update routing configuration for placeholder navigation
  - Add placeholder routes for user repositories, starred, and organizations
  - Ensure proper parameter passing for user login in routes
  - Create basic placeholder screens for navigation destinations
  - Test deep linking to user details screen with /:login pattern
  - _Requirements: 1.1, 2.2, 2.4, 2.6_