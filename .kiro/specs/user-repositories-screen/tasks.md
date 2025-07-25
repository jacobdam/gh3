# Implementation Plan

- [ ] 1. Set up user repositories screen module structure
  - Create directory structure following the established screen module pattern
  - Set up the basic files: screen, viewmodel, route, route provider, viewmodel factory
  - _Requirements: 1.1, 7.1_

- [ ] 2. Create GraphQL query for user repositories with pagination
  - Define user_repositories_viewmodel.graphql with repository query including pagination
  - Include all required fields: name, description, language, stars, forks, privacy, timestamps
  - Add support for filtering by repository type and sorting options
  - Run build_runner to generate GraphQL types
  - _Requirements: 1.1, 3.1, 4.1, 5.1, 6.1-6.6_

- [ ] 3. Implement UserRepositoriesViewModel with state management
  - Create ViewModel extending DisposableViewModel with all required state properties
  - Implement repository loading with GraphQL integration
  - Add pagination support with race condition protection
  - Implement search functionality with real-time filtering
  - Add repository type filtering (all, private, source, fork, mirror, template, archived)
  - Add language filtering with language list extraction
  - Add sorting functionality for all specified sort options
  - Include error handling and loading states
  - _Requirements: 1.1-1.4, 2.1-2.4, 3.1-3.4, 4.1-4.4, 5.1-5.5_

- [ ] 4. Create UserRepositoriesViewModelFactory
  - Implement factory class with @injectable annotation
  - Accept required dependencies (Ferry client, user login parameter)
  - Create factory method to instantiate ViewModel with dependencies
  - _Requirements: 1.1_

- [ ] 5. Implement UserRepositoriesScreen with search and filter UI
  - Create StatefulWidget following established screen pattern
  - Implement AppBar with "Repositories" title and back navigation
  - Add search field at the top of the screen
  - Create filter chips section showing active filters
  - Add filter button to open filter options
  - Add sort button/dropdown for sort options
  - Implement pull-to-refresh functionality
  - _Requirements: 1.1-1.4, 2.1-2.4, 7.1-7.3, 8.1-8.4_

- [ ] 6. Implement repository list with infinite scroll
  - Use CustomScrollView with SliverList for efficient scrolling
  - Integrate existing RepositoryCard widget with fromFragment pattern
  - Add ScrollController for infinite scroll detection (200px threshold)
  - Implement automatic load more when scrolling near bottom
  - Add loading indicator at bottom during pagination
  - Handle empty states (no repositories vs no search results)
  - Add proper loading states with shimmer/skeleton loading
  - _Requirements: 1.1-1.4, 6.1-6.6_

- [ ] 7. Enhance RepositoryCard widget for additional requirements
  - Add support for private repository indicator
  - Add last updated timestamp display
  - Ensure all required repository information is displayed
  - Update GraphQL fragment if needed for additional fields
  - _Requirements: 6.1-6.6_

- [ ] 8. Implement filter and sort UI components
  - Create filter bottom sheet with all repository type options
  - Add language filter with dynamic language list from repositories
  - Create sort options UI (dropdown or bottom sheet)
  - Add clear filters functionality
  - Show active filter indicators in the UI
  - _Requirements: 3.1-3.4, 4.1-4.4, 5.1-5.5, 8.1-8.4_

- [ ] 9. Create UserRepositoriesRoute for typed navigation
  - Implement AppRoute subclass with user login parameter
  - Define proper path structure for the route
  - _Requirements: 7.1-7.3_

- [ ] 10. Create UserRepositoriesRouteProvider
  - Implement RouteProvider interface with @Named and @Singleton annotations
  - Configure GoRoute with path parameter for user login
  - Integrate with UserRepositoriesViewModelFactory
  - Wire up screen instantiation with ViewModel
  - _Requirements: 1.1, 7.1-7.3_

- [ ] 11. Add navigation integration to existing screens
  - Update user profile or relevant screens to navigate to repositories screen
  - Add proper navigation calls using the new route
  - Test navigation flow from other parts of the app
  - _Requirements: 1.4, 7.1-7.3_

- [ ] 12. Write comprehensive unit tests for ViewModel
  - Test repository loading and pagination functionality
  - Test search filtering with various query inputs
  - Test repository type filtering for all types
  - Test language filtering functionality
  - Test all sorting options and their behavior
  - Test error handling scenarios
  - Test race condition protection in pagination
  - Mock GraphQL client for isolated testing
  - _Requirements: 1.1-1.4, 2.1-2.4, 3.1-3.4, 4.1-4.4, 5.1-5.5_

- [ ] 13. Write widget tests for UserRepositoriesScreen
  - Test screen rendering with different states (loading, loaded, error)
  - Test search input functionality and UI updates
  - Test filter UI interactions and state changes
  - Test sort option selection and application
  - Test pull-to-refresh functionality
  - Test infinite scroll behavior
  - Test empty state displays
  - Test navigation interactions
  - _Requirements: 1.1-1.4, 2.1-2.4, 7.1-7.3, 8.1-8.4_

- [ ] 14. Write integration tests for complete user flow
  - Test end-to-end repository browsing flow
  - Test search and filter combinations
  - Test pagination with real GraphQL integration
  - Test navigation from other screens to repositories screen
  - Test error recovery scenarios
  - _Requirements: 1.1-1.4, 2.1-2.4, 3.1-3.4, 4.1-4.4, 5.1-5.5_

- [ ] 15. Add accessibility support
  - Add semantic labels for search field and filter controls
  - Ensure repository cards have descriptive accessibility labels
  - Add screen reader announcements for filter state changes
  - Test keyboard navigation through the interface
  - Add focus indicators for all interactive elements
  - _Requirements: 8.1-8.4_

- [ ] 16. Performance optimization and final polish
  - Optimize scroll performance with proper widget disposal
  - Add debouncing to search input to prevent excessive filtering
  - Implement proper memory management for large repository lists
  - Add loading states and transitions for better UX
  - Test with large repository datasets for performance
  - _Requirements: 1.1-1.4, 2.1-2.4_