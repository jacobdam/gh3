# UI System Architecture

## Overview

The gh3 application uses a comprehensive Material Design 3-based UI system with reusable widgets and consistent layout patterns. This document defines the high-level widget architecture, information display specifications, and design patterns for all GitHub mobile screens.

## Design Principles

### Information Hierarchy
- **Primary Information**: Most important data displayed prominently (titles, names, primary status)
- **Secondary Information**: Supporting details (descriptions, metadata, counts)
- **Tertiary Information**: Additional context (timestamps, minor details, helper text)
- **Interactive Elements**: Clear action affordances with proper touch targets (44dp minimum)
- **Status Indicators**: System state communication with color-coded badges and consistent meaning

### Material Design 3 Foundation
- Consistent spacing, typography, and colors
- Accessible contrast ratios and touch targets
- Dynamic color theming support
- Elevation and surface treatment
- Motion and interaction patterns

## Core Design Tokens

### Colors
```dart
// Primary GitHub brand colors
primary: Color(0xFF0969DA)
onPrimary: Color(0xFFFFFFFF)
primaryContainer: Color(0xFFDDE6F4)
onPrimaryContainer: Color(0xFF0A1929)

// GitHub-specific semantic colors
success: Color(0xFF1A7F37)  // Open issues, success states
warning: Color(0xFFBF8700)  // Warnings, pending states
error: Color(0xFFCF222E)    // Closed issues, error states
merged: Color(0xFF8250DF)   // Merged PRs
draft: Color(0xFF656D76)    // Draft PRs, disabled states
```

### Typography Scale
- **Headline Large**: 32sp, titles and hero text
- **Headline Medium**: 28sp, screen titles
- **Title Large**: 22sp, section headers
- **Title Medium**: 16sp, card titles
- **Body Large**: 16sp, primary content
- **Body Medium**: 14sp, secondary content
- **Label Large**: 14sp, button text
- **Label Medium**: 12sp, metadata and captions

### Spacing System
- **4dp**: Micro spacing (icon gaps)
- **8dp**: Small spacing (chip gaps)
- **12dp**: Medium spacing (section padding)
- **16dp**: Standard spacing (card padding)
- **20dp**: Large spacing (section margins)
- **24dp**: XL spacing (screen padding)
- **32dp**: XXL spacing (major sections)

## 1. Layout Widgets

### GHScreenTemplate
**Purpose**: Standard screen structure for all GitHub screens

**Information Display**:
- Screen title in app bar with consistent styling
- Optional back navigation with proper touch target
- Action buttons (star, share, etc.) in app bar
- Optional floating action button for primary actions
- Consistent padding and spacing throughout

**Usage**:
```dart
GHScreenTemplate(
  title: "Repository Name",
  actions: [StarButton(), ShareButton()],
  floatingAction: FloatingStarButton(),
  body: screenContent,
)
```

**Design Specifications**:
- App bar height: 56dp
- App bar title: Title Large typography
- Action button touch target: 48x48dp
- Screen padding: 16dp horizontal, 0dp vertical
- Floating action button: 56x56dp

### GHListTemplate  
**Purpose**: Standard list/feed layout with pull-to-refresh and search

**Information Display**:
- Optional search bar at top with clear placeholder text
- Optional filter chips below search with count indicators
- Scrollable list with pull-to-refresh capability
- Loading states with skeleton screens
- Empty states with helpful messaging
- Infinite scroll pagination with loading indicators

**Usage**:
```dart
GHListTemplate(
  searchHint: "Search issues...",
  filters: [OpenFilter(), ClosedFilter(), LabelFilters()],
  items: listOfItems,
  onRefresh: () => refresh(),
  onLoadMore: () => loadMore(),
)
```

**Design Specifications**:
- Search bar height: 48dp
- Filter chip height: 32dp
- List item minimum height: 72dp
- Pull-to-refresh trigger: 80dp
- Loading indicator size: 24x24dp

### GHContentTemplate
**Purpose**: Single content view with sections and metadata

**Information Display**:
- Main content area with vertical scrolling
- Clear section dividers and spacing
- Metadata displayed in structured format
- Action buttons contextually placed
- Responsive layout for different screen sizes

**Usage**:
```dart
GHContentTemplate(
  header: IssueHeader(),
  sections: [
    ContentSection(), 
    CommentsSection(),
    MetadataSection()
  ],
  actions: [EditButton(), CommentButton()],
)
```

**Design Specifications**:
- Section spacing: 24dp between major sections
- Content padding: 16dp horizontal
- Section divider: 1dp height with surface variant color
- Action button spacing: 8dp between buttons

## 2. Header & Summary Widgets

### GHEntityHeader
**Purpose**: Display primary information about any GitHub entity (repository, user, issue)

**Information Display**:
- Entity name/title with primary typography
- Description/subtitle with secondary typography
- Key statistics (stars, forks, followers) with icons
- Status indicators (open/closed, public/private) with color coding
- Language indicators with color dots
- Action buttons (star, follow, watch) with proper spacing

**Usage**:
```dart
GHEntityHeader(
  title: "facebook/react",
  description: "A declarative library for building UIs",
  avatar: RepositoryIcon(),
  stats: [
    StatItem(icon: Icons.star, count: 45200, label: "stars"),
    StatItem(icon: Icons.fork, count: 8900, label: "forks"),
    StatItem(colorDot: Colors.blue, label: "JavaScript"),
  ],
  status: PublicBadge(),
  actions: [StarButton(), WatchButton()],
)
```

**Design Specifications**:
- Header padding: 16dp all sides
- Title typography: Headline Medium
- Description typography: Body Large
- Stat icon size: 16x16dp
- Language color dot: 12x12dp circle
- Action button minimum size: 48x48dp

### GHUserHeader
**Purpose**: Display user/organization profile information

**Information Display**:
- Profile avatar (48x48dp) with rounded corners
- Display name with primary typography
- Username with secondary typography and @ prefix
- Bio/description with proper line height
- Location and company with icons
- Follower/following counts with clear labels
- Join date information

**Usage**:
```dart
GHUserHeader(
  avatar: CircleAvatar(url: user.avatarUrl),
  displayName: "John Doe",
  username: "@johndoe",
  bio: "Software developer passionate about open source",
  location: "San Francisco, CA",
  company: "GitHub",
  stats: [
    StatItem(count: 1200, label: "followers"),
    StatItem(count: 345, label: "following"),
  ],
)
```

**Design Specifications**:
- Avatar size: 48x48dp with 8dp radius
- Display name typography: Title Large
- Username typography: Body Medium with onSurfaceVariant color
- Bio typography: Body Medium with 1.5 line height
- Metadata icon size: 16x16dp
- Stat spacing: 16dp between items

## 3. Navigation & Menu Widgets

### GHNavigationGrid
**Purpose**: Grid of navigation cards for main actions

**Information Display**:
- Action title with clear hierarchy
- Brief description for context
- Icon representation for quick recognition
- Count badges when applicable
- Visual hierarchy with consistent spacing

**Usage**:
```dart
GHNavigationGrid(
  items: [
    NavItem(
      icon: Icons.code,
      title: "Code",
      description: "Browse repository files",
      onTap: () => navigateToCode(),
    ),
    NavItem(
      icon: Icons.bug_report,
      title: "Issues",
      badge: "23 open",
      onTap: () => navigateToIssues(),
    ),
    NavItem(
      icon: Icons.merge_type,
      title: "Pull Requests", 
      badge: "5 open",
      onTap: () => navigateToPRs(),
    ),
  ],
)
```

**Design Specifications**:
- Grid item height: 88dp minimum
- Grid spacing: 8dp between items
- Icon size: 24x24dp
- Title typography: Title Medium
- Description typography: Body Medium
- Badge typography: Label Medium

### GHTabMenu
**Purpose**: Horizontal scrollable tab navigation

**Information Display**:
- Tab titles with clear active/inactive states
- Count badges for relevant tabs
- Scroll indicators when content overflows
- Smooth transition animations

**Usage**:
```dart
GHTabMenu(
  tabs: [
    TabItem(title: "Code", isActive: true),
    TabItem(title: "Issues", badge: "23"),
    TabItem(title: "Pull Requests", badge: "5"),
    TabItem(title: "Actions"),
  ],
  onTabChanged: (index) => switchTab(index),
)
```

**Design Specifications**:
- Tab height: 48dp
- Tab padding: 16dp horizontal, 12dp vertical
- Active indicator height: 2dp
- Badge size: minimum 16x16dp
- Typography: Label Large

## 4. Content Display Widgets

### GHIssueCard
**Purpose**: Display issue/PR summary in lists

**Information Display**:
- Issue number with # prefix for identification
- Issue title with proper truncation
- Status icon and badge (open/closed/merged) with semantic colors
- Labels as colored chips with consistent styling
- Author avatar (24x24dp) and name
- Creation/update timestamp in relative format
- Assignee information when present
- Comment count indicator with icon

**Usage**:
```dart
GHIssueCard(
  number: 1234,
  title: "Add dark mode support",
  status: IssueStatus.open,
  author: UserMini(avatar: avatar, name: "johndoe"),
  timestamp: "2 hours ago",
  labels: ["enhancement", "ui"],
  commentCount: 5,
  assignee: UserMini(avatar: avatar, name: "janedoe"),
  onTap: () => openIssue(1234),
)
```

**Design Specifications**:
- Card padding: 16dp all sides
- Card elevation: 1dp
- Status icon size: 16x16dp
- Author avatar size: 24x24dp
- Label chip height: 24dp
- Comment icon size: 16x16dp
- Minimum touch target: 48dp height

### GHFileCard
**Purpose**: Display file/folder information in directory listings

**Information Display**:
- File/folder icon based on type and extension
- File name with proper truncation
- Last commit message with ellipsis
- Last modified timestamp in relative format
- File size for files (formatted appropriately)
- Directory indicator for folders
- Author information for last modification

**Usage**:
```dart
GHFileCard(
  name: "README.md",
  type: FileType.markdown,
  lastCommit: "Update installation instructions",
  lastModified: "3 days ago",
  author: "johndoe",
  size: "2.4 KB",
  onTap: () => openFile("README.md"),
)
```

**Design Specifications**:
- List item height: 72dp
- Icon size: 24x24dp
- File name typography: Body Large
- Commit message typography: Body Medium
- Metadata typography: Label Medium
- Chevron icon: 16x16dp

### GHRepositoryCard
**Purpose**: Display repository summary in lists

**Information Display**:
- Repository name and owner with clear hierarchy
- Description text with proper line limits
- Primary language with color indicator dot
- Star and fork counts with icons
- Last updated timestamp
- Visibility indicator (public/private badge)

**Usage**:
```dart
GHRepositoryCard(
  owner: "facebook",
  name: "react",
  description: "A declarative library for building UIs",
  language: Language(name: "JavaScript", color: Colors.yellow),
  starCount: 45200,
  forkCount: 8900,
  lastUpdated: "2 hours ago",
  visibility: Visibility.public,
  onTap: () => openRepository("facebook/react"),
)
```

**Design Specifications**:
- Card padding: 16dp
- Card spacing: 8dp between cards
- Owner/name typography: Title Medium
- Description typography: Body Medium
- Language dot size: 12x12dp
- Stat icon size: 16x16dp

## 5. Filter & Search Widgets

### GHFilterBar
**Purpose**: Horizontal scrollable filter options

**Information Display**:
- Filter categories as chips with clear labels
- Active/inactive states with color differentiation
- Count indicators for each filter category
- Clear all filters option when filters are active
- Smooth horizontal scrolling

**Usage**:
```dart
GHFilterBar(
  filters: [
    FilterChip(label: "Open", count: 23, isActive: true),
    FilterChip(label: "Closed", count: 145, isActive: false),
    FilterChip(label: "bug", color: Colors.red, isActive: false),
    FilterChip(label: "enhancement", color: Colors.blue, isActive: false),
  ],
  onFilterChanged: (filter) => applyFilter(filter),
  onClearAll: () => clearFilters(),
)
```

**Design Specifications**:
- Filter chip height: 32dp
- Chip spacing: 8dp horizontal
- Active chip background: primaryContainer
- Inactive chip background: surfaceVariant
- Count badge: minimum 16x16dp

### GHSearchHeader
**Purpose**: Search input with suggestions and filters

**Information Display**:
- Search input field with descriptive placeholder
- Search suggestions dropdown with recent/popular queries
- Quick filter buttons below input
- Results count indicator
- Clear search functionality

**Usage**:
```dart
GHSearchHeader(
  placeholder: "Search issues and pull requests",
  suggestions: ["is:open", "is:closed", "label:bug"],
  quickFilters: ["Open issues", "My issues", "Assigned to me"],
  resultCount: "142 results",
  onSearch: (query) => performSearch(query),
)
```

**Design Specifications**:
- Search field height: 48dp
- Search field radius: 8dp
- Suggestion item height: 40dp
- Quick filter chip height: 32dp
- Results text typography: Label Medium

## 6. Status & Metadata Widgets

### GHStatusIndicator
**Purpose**: Display status information with appropriate semantic colors

**Information Display**:
- Status text with clear labeling
- Color-coded background following GitHub conventions
- Status icon when applicable for better recognition
- Timestamp of status change for context

**Usage**:
```dart
GHStatusIndicator(
  status: Status.open,
  text: "Open",
  timestamp: "opened 2 days ago",
  icon: Icons.error_outline,
  color: Colors.green,
)
```

**Design Specifications**:
- Badge height: 24dp minimum
- Badge radius: 12dp (pill shape)
- Icon size: 16x16dp
- Typography: Label Medium
- Color mapping:
  - Open: success color (#1A7F37)
  - Closed: error color (#CF222E)
  - Merged: merged color (#8250DF)
  - Draft: draft color (#656D76)

### GHMetadataSection
**Purpose**: Display metadata information in structured format

**Information Display**:
- Key-value pairs with clear visual hierarchy
- Links to related entities with proper styling
- Expandable/collapsible sections for space efficiency
- Copy-to-clipboard functionality for relevant data

**Usage**:
```dart
GHMetadataSection(
  title: "Details",
  items: [
    MetadataItem(label: "Assignees", value: "johndoe, janedoe"),
    MetadataItem(label: "Labels", value: LabelChips()),
    MetadataItem(label: "Milestone", value: "v2.0", isLink: true),
    MetadataItem(label: "Projects", value: "Mobile App Redesign"),
  ],
  isCollapsible: true,
)
```

**Design Specifications**:
- Section padding: 16dp
- Item spacing: 8dp vertical
- Label typography: Label Medium
- Value typography: Body Medium
- Link color: primary color
- Collapse icon size: 16x16dp

## 7. Action Widgets

### GHActionButton
**Purpose**: Primary and secondary action buttons

**Information Display**:
- Action text/label with clear hierarchy
- Optional icon for better recognition
- Loading states with spinner animation
- Disabled states with reduced opacity
- Count indicators (for star, watch, etc.)

**Usage**:
```dart
GHActionButton(
  label: "Star",
  icon: Icons.star_border,
  count: 1200,
  style: ActionStyle.primary,
  isLoading: false,
  onPressed: () => toggleStar(),
)
```

**Design Specifications**:
- Button height: 40dp (medium), 48dp (large)
- Button radius: 8dp
- Icon size: 18x18dp
- Typography: Label Large
- Minimum touch target: 48x48dp
- Loading spinner: 16x16dp

### GHActionSheet
**Purpose**: Bottom sheet with multiple action options

**Information Display**:
- Sheet title with clear context
- List of available actions with descriptions
- Destructive action indicators with warning colors
- Icons for each action for quick recognition
- Proper spacing and touch targets

**Usage**:
```dart
GHActionSheet(
  title: "Repository Actions",
  actions: [
    ActionItem(
      title: "Star repository", 
      icon: Icons.star,
      onTap: () => star(),
    ),
    ActionItem(
      title: "Watch repository",
      icon: Icons.visibility,
      onTap: () => watch(),
    ),
    ActionItem(
      title: "Report issue",
      icon: Icons.flag,
      isDestructive: true,
      onTap: () => report(),
    ),
  ],
)
```

**Design Specifications**:
- Sheet max height: 60% of screen
- Sheet radius: 16dp top corners
- Action item height: 56dp
- Action icon size: 24x24dp
- Title typography: Title Medium
- Action typography: Body Large

## 8. Common Layout Patterns

### GHFeedLayout
**Purpose**: Standard feed/timeline layout pattern

**Information Display**:
- Chronological list of items with clear time grouping
- Time-based grouping headers (Today, Yesterday, etc.)
- Infinite scroll with smooth loading indicators
- Pull-to-refresh capability with visual feedback
- Empty state messaging with helpful guidance

**Usage**:
```dart
GHFeedLayout(
  groupBy: GroupBy.date,
  items: [
    FeedGroup(
      header: "Today",
      items: [item1, item2, item3],
    ),
    FeedGroup(
      header: "Yesterday", 
      items: [item4, item5],
    ),
  ],
  emptyState: EmptyFeedMessage(
    icon: Icons.inbox,
    title: "No recent activity",
    subtitle: "Activity will appear here as it happens",
  ),
)
```

**Design Specifications**:
- Group header height: 40dp
- Group header typography: Title Medium
- Item spacing: 8dp between items
- Section spacing: 24dp between groups
- Empty state icon size: 48x48dp

### GHMasterDetailLayout
**Purpose**: Two-pane layout for tablets/wide screens

**Information Display**:
- Master list on left (30-40% width) with clear selection
- Detail view on right (60-70% width) with full content
- Selected item highlighting in master list
- Responsive behavior for mobile (stack vertically)

**Usage**:
```dart
GHMasterDetailLayout(
  masterPane: IssueList(
    items: issues,
    selectedId: currentIssueId,
    onSelectionChanged: (id) => selectIssue(id),
  ),
  detailPane: IssueDetail(
    issue: selectedIssue,
  ),
  breakpoint: 600, // Switch to stacked on mobile
)
```

**Design Specifications**:
- Breakpoint: 600dp width
- Master pane width: 40% on tablet
- Detail pane width: 60% on tablet
- Divider width: 1dp
- Selected item background: primaryContainer

### GHModalLayout
**Purpose**: Full-screen modal presentation

**Information Display**:
- Modal header with clear title and close button
- Scrollable content area with proper padding
- Optional bottom action bar with primary/secondary actions
- Backdrop dimming for focus

**Usage**:
```dart
GHModalLayout(
  title: "Create New Issue",
  content: IssueForm(),
  actions: [
    SecondaryButton(text: "Cancel"),
    PrimaryButton(text: "Create Issue"),
  ],
  onClose: () => closeModal(),
)
```

**Design Specifications**:
- Modal radius: 16dp top corners
- Header height: 56dp
- Close button size: 48x48dp
- Content padding: 16dp horizontal
- Action bar height: 72dp

## 9. Specialized Content Widgets

### GHCodeViewer
**Purpose**: Display code content with syntax highlighting

**Information Display**:
- Syntax-highlighted code with language-appropriate colors
- Optional line numbers with proper alignment
- Copy to clipboard functionality with user feedback
- Language indicator badge
- File size and encoding information
- Horizontal scroll for long lines

**Usage**:
```dart
GHCodeViewer(
  content: codeString,
  language: "dart",
  showLineNumbers: true,
  fileName: "main.dart",
  fileSize: "2.4 KB",
  encoding: "UTF-8",
  onCopy: () => copyCode(),
)
```

**Design Specifications**:
- Font family: monospace
- Font size: 14sp
- Line height: 1.4
- Line number width: 48dp
- Code padding: 16dp
- Copy button size: 32x32dp

### GHMarkdownViewer
**Purpose**: Display markdown content (README, comments, etc.)

**Information Display**:
- Rendered markdown with GitHub-style formatting
- Code syntax highlighting in code blocks
- Link handling for GitHub references (@mentions, #issues)
- Image display with responsive sizing
- Table formatting with proper alignment

**Usage**:
```dart
GHMarkdownViewer(
  content: markdownString,
  baseUrl: "https://github.com/owner/repo",
  onLinkTap: (url) => handleLink(url),
  theme: MarkdownTheme.github,
)
```

**Design Specifications**:
- Base font size: 16sp (Body Large)
- Heading scale: 1.25 ratio
- Code font: monospace, 14sp
- Link color: primary color
- Block quote border: 4dp left, primaryContainer color

### GHCommentThread
**Purpose**: Display threaded comments/discussions

**Information Display**:
- User avatars (32x32dp) with proper spacing
- User names with timestamp information
- Nested reply structure with indentation
- Reaction indicators with counts
- Edit/delete actions when applicable
- Threading lines for visual hierarchy

**Usage**:
```dart
GHCommentThread(
  comments: [
    Comment(
      author: User(name: "johndoe", avatar: avatar),
      content: "This looks good to me!",
      timestamp: "2 hours ago",
      reactions: [Reaction.thumbsUp(3), Reaction.heart(1)],
      replies: [nestedComment],
    ),
  ],
  onReply: (commentId) => replyToComment(commentId),
  onReact: (commentId, reaction) => addReaction(commentId, reaction),
)
```

**Design Specifications**:
- Avatar size: 32x32dp
- Reply indentation: 48dp
- Comment padding: 16dp
- Reaction button size: 32x24dp
- Threading line width: 2dp
- Threading line color: surfaceVariant

## Implementation Guidelines

### Widget Architecture
- All widgets extend StatelessWidget when possible
- Use composition over inheritance
- Implement proper const constructors
- Follow single responsibility principle

### Accessibility
- Minimum touch target size: 48x48dp
- Color contrast ratio: 4.5:1 for normal text, 3:1 for large text
- Screen reader support with semantic labels
- Keyboard navigation support

### Performance
- Use const constructors for static widgets
- Implement proper key usage for list items
- Lazy loading for large lists
- Image caching and optimization

### Testing
- Unit tests for all business logic
- Widget tests for UI components
- Integration tests for user flows
- Accessibility testing with screen readers

## Migration Strategy

### Phase 1: Core Components
1. Implement design tokens and theme
2. Create base layout widgets
3. Build core navigation components

### Phase 2: Content Widgets
1. Implement specialized GitHub widgets
2. Create filter and search components
3. Build action and status widgets

### Phase 3: Screen Implementation
1. Migrate existing screens to new system
2. Implement P1 screens using widget system
3. Create comprehensive widget documentation

### Phase 4: Enhancement
1. Add advanced interaction patterns
2. Implement micro-interactions and animations
3. Optimize performance and accessibility

This UI system provides a comprehensive foundation for building consistent, accessible, and maintainable GitHub mobile interfaces while following Material Design 3 principles and GitHub-specific design patterns.

## Screen Layout Specifications

### Home Screen Layout
**Purpose**: Authenticated user dashboard showing personalized GitHub activity

**Layout Structure**:
```dart
GHScreenTemplate(
  title: "GitHub",
  showBackButton: false,
  actions: [NotificationButton(), ProfileButton()],
  body: GHListTemplate(
    searchHint: "Search repositories, users, issues...",
    onRefresh: () => refreshFeed(),
    children: [
      // User profile summary
      GHUserSummaryCard(
        user: currentUser,
        onTap: () => navigateToProfile(),
      ),
      
      // Quick actions grid
      GHNavigationGrid(
        title: "Quick Actions",
        items: [
          NavItem(icon: Icons.star, title: "Starred", count: "45"),
          NavItem(icon: Icons.folder, title: "Repositories", count: "12"),
          NavItem(icon: Icons.people, title: "Organizations", count: "3"),
          NavItem(icon: Icons.notifications, title: "Notifications"),
        ],
      ),
      
      // Recent activity feed
      GHFeedLayout(
        title: "Recent Activity",
        groupBy: GroupBy.date,
        items: activityItems,
        emptyState: EmptyFeedMessage(
          icon: Icons.timeline,
          title: "No recent activity",
          subtitle: "Your GitHub activity will appear here",
        ),
      ),
      
      // Trending repositories
      GHContentSection(
        title: "Trending Today",
        actions: [TextButton(text: "See all")],
        content: Column(
          children: trendingRepos.map((repo) => 
            GHRepositoryCard.fromRepo(repo)
          ).toList(),
        ),
      ),
    ],
  ),
)
```

**Information Display**:
- User avatar and basic profile info at top
- Quick access to starred repos, personal repos, organizations
- Chronological activity feed with time grouping
- Trending repositories discovery section
- Search bar for global GitHub search
- Notification indicator in app bar

**Design Specifications**:
- User summary card height: 88dp
- Quick action grid: 2x2 layout on mobile
- Activity item height: 72dp minimum
- Trending repo card: 120dp height
- Pull-to-refresh threshold: 80dp

### User Details Screen Layout
**Purpose**: Display comprehensive user profile information and repositories

**Layout Structure**:
```dart
GHScreenTemplate(
  title: user.displayName ?? user.username,
  actions: [ShareButton(), MoreActionsButton()],
  body: GHListTemplate(
    onRefresh: () => refreshUserData(),
    children: [
      // User profile header
      GHUserHeader(
        avatar: CircleAvatar(radius: 40, url: user.avatarUrl),
        displayName: user.displayName,
        username: user.username,
        bio: user.bio,
        location: user.location,
        company: user.company,
        website: user.website,
        stats: [
          StatItem(count: user.followers, label: "followers"),
          StatItem(count: user.following, label: "following"),
          StatItem(count: user.publicRepos, label: "repositories"),
        ],
        joinDate: user.createdAt,
      ),
      
      // Action buttons
      Row(
        children: [
          Expanded(child: GHActionButton(
            label: isFollowing ? "Unfollow" : "Follow",
            style: ActionStyle.primary,
            onPressed: () => toggleFollow(),
          )),
          SizedBox(width: 8),
          GHActionButton(
            icon: Icons.message,
            style: ActionStyle.secondary,
            onPressed: () => openChat(),
          ),
        ],
      ),
      
      // Navigation tabs
      GHTabMenu(
        tabs: [
          TabItem(title: "Repositories", badge: "${user.publicRepos}"),
          TabItem(title: "Starred", badge: "${user.starredRepos}"),
          TabItem(title: "Organizations", badge: "${user.organizations.length}"),
          TabItem(title: "Projects"),
        ],
        selectedIndex: currentTab,
        onTabChanged: (index) => switchTab(index),
      ),
      
      // Tab content
      if (currentTab == 0) ...[
        // Repositories tab
        GHFilterBar(
          filters: [
            FilterChip(label: "All", isActive: true),
            FilterChip(label: "Sources"),
            FilterChip(label: "Forks"),
            FilterChip(label: "Archived"),
          ],
        ),
        SearchBar(hintText: "Find a repository..."),
        ...repositories.map((repo) => GHRepositoryCard.fromRepo(repo)),
      ],
      
      if (currentTab == 1) ...[
        // Starred repositories
        SearchBar(hintText: "Search starred repositories..."),
        ...starredRepos.map((repo) => GHRepositoryCard.fromRepo(repo)),
      ],
      
      // Additional tabs content...
    ],
  ),
)
```

**Information Display**:
- Large profile avatar (80x80dp) with full user metadata
- Follow/unfollow action with current relationship status
- Tabbed navigation for different content types
- Repository listings with search and filter capabilities
- Organization memberships and projects
- Social proof through follower/following counts

**Design Specifications**:
- Profile avatar: 80x80dp with 16dp radius
- Header section height: 280dp minimum
- Tab bar height: 48dp
- Repository card spacing: 8dp vertical
- Action button height: 48dp

### Repository Details Screen Layout
**Purpose**: Display comprehensive repository information and navigation

**Layout Structure**:
```dart
GHScreenTemplate(
  title: "${repo.owner}/${repo.name}",
  actions: [StarButton(), ShareButton(), MoreActionsButton()],
  floatingAction: FloatingActionButton(
    child: Icon(repo.isStarred ? Icons.star : Icons.star_border),
    onPressed: () => toggleStar(),
  ),
  body: GHContentTemplate(
    sections: [
      // Repository header
      GHEntityHeader(
        title: repo.name,
        subtitle: repo.description,
        avatar: repo.owner.avatarUrl != null 
          ? CircleAvatar(url: repo.owner.avatarUrl) 
          : null,
        stats: [
          StatItem(icon: Icons.star, count: repo.starCount, label: "stars"),
          StatItem(icon: Icons.fork_right, count: repo.forkCount, label: "forks"),
          StatItem(icon: Icons.visibility, count: repo.watcherCount, label: "watching"),
          if (repo.language != null)
            StatItem(
              colorIndicator: repo.languageColor,
              label: repo.language!,
            ),
        ],
        status: repo.isPrivate ? PrivateBadge() : PublicBadge(),
        actions: [
          GHActionButton(
            label: "Watch",
            icon: Icons.visibility,
            style: ActionStyle.secondary,
            onPressed: () => toggleWatch(),
          ),
          GHActionButton(
            label: "Fork",
            icon: Icons.fork_right,
            style: ActionStyle.secondary,
            onPressed: () => forkRepository(),
          ),
        ],
      ),
      
      // Repository navigation
      GHNavigationMenu(
        items: [
          GHNavigationItem(
            icon: Icons.code,
            title: "Code",
            subtitle: "Browse source files",
            onTap: () => navigateToCode(),
          ),
          GHNavigationItem(
            icon: Icons.bug_report,
            title: "Issues",
            badge: "${repo.openIssues}",
            subtitle: "${repo.openIssues} open, ${repo.closedIssues} closed",
            onTap: () => navigateToIssues(),
          ),
          GHNavigationItem(
            icon: Icons.merge_type,
            title: "Pull Requests",
            badge: "${repo.openPRs}",
            subtitle: "${repo.openPRs} open, ${repo.mergedPRs} merged",
            onTap: () => navigateToPRs(),
          ),
          GHNavigationItem(
            icon: Icons.play_circle,
            title: "Actions",
            trailing: repo.lastWorkflowStatus != null 
              ? GHStatusIndicator(status: repo.lastWorkflowStatus!) 
              : null,
            onTap: () => navigateToActions(),
          ),
          GHNavigationItem(
            icon: Icons.security,
            title: "Security",
            onTap: () => navigateToSecurity(),
          ),
          GHNavigationItem(
            icon: Icons.insights,
            title: "Insights",
            onTap: () => navigateToInsights(),
          ),
        ],
      ),
      
      // Repository metadata
      GHMetadataSection(
        title: "About",
        items: [
          if (repo.topics.isNotEmpty)
            MetadataItem(
              label: "Topics",
              value: Wrap(
                children: repo.topics.map((topic) => 
                  GHChip(label: topic)
                ).toList(),
              ),
            ),
          if (repo.license != null)
            MetadataItem(label: "License", value: repo.license!),
          if (repo.homepage != null)
            MetadataItem(
              label: "Website", 
              value: repo.homepage!, 
              isLink: true,
            ),
          MetadataItem(
            label: "Last updated", 
            value: formatDate(repo.updatedAt),
          ),
        ],
      ),
      
      // README section
      if (repo.readme != null)
        GHContentSection(
          title: "README",
          content: GHMarkdownViewer(
            content: repo.readme!,
            baseUrl: repo.url,
          ),
        ),
      
      // Recent releases
      if (repo.releases.isNotEmpty)
        GHContentSection(
          title: "Releases",
          actions: [TextButton(text: "View all")],
          content: Column(
            children: repo.releases.take(3).map((release) =>
              GHReleaseCard(release: release)
            ).toList(),
          ),
        ),
      
      // Contributors
      GHContentSection(
        title: "Contributors",
        actions: [TextButton(text: "View all ${repo.contributorCount}")],
        content: Row(
          children: repo.topContributors.map((contributor) =>
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(contributor.avatarUrl),
              ),
            )
          ).toList(),
        ),
      ),
    ],
  ),
)
```

**Information Display**:
- Repository name, description, and key statistics
- Owner information with avatar
- Star/watch/fork actions prominently displayed
- Clear navigation to different repository sections
- README content with proper markdown rendering
- Recent releases and contributor information
- Repository metadata (license, topics, links)

**Design Specifications**:
- Header section height: 200dp minimum
- Navigation menu item height: 64dp
- README section collapsible after 300dp
- Contributor avatar size: 40x40dp
- Floating action button: 56x56dp

### Starred Repositories Screen Layout
**Purpose**: Display user's starred repositories with search and filtering

**Layout Structure**:
```dart
GHScreenTemplate(
  title: "Starred Repositories",
  body: GHListTemplate(
    searchHint: "Search starred repositories...",
    filters: [
      FilterChip(label: "All", count: starredRepos.length, isActive: true),
      FilterChip(label: "Recently starred", isActive: false),
      FilterChip(label: "Recently active", isActive: false),
      ...languageFilters.map((lang) => FilterChip(
        label: lang.name,
        count: lang.count,
        colorIndicator: lang.color,
      )),
    ],
    onRefresh: () => refreshStarredRepos(),
    children: [
      // Filter summary
      if (hasActiveFilters)
        GHCard(
          child: Row(
            children: [
              Text(
                "${filteredRepos.length} of ${starredRepos.length} repositories",
                style: GHTokens.bodyMedium,
              ),
              Spacer(),
              TextButton(
                onPressed: () => clearFilters(),
                child: Text("Clear filters"),
              ),
            ],
          ),
        ),
      
      // Sort options
      GHCard(
        child: Row(
          children: [
            Icon(Icons.sort, size: 16),
            SizedBox(width: 8),
            Text("Sort by:", style: GHTokens.labelMedium),
            SizedBox(width: 8),
            DropdownButton<SortOption>(
              value: currentSort,
              items: [
                DropdownMenuItem(
                  value: SortOption.recentlyStarred,
                  child: Text("Recently starred"),
                ),
                DropdownMenuItem(
                  value: SortOption.recentlyUpdated,
                  child: Text("Recently updated"),
                ),
                DropdownMenuItem(
                  value: SortOption.name,
                  child: Text("Name"),
                ),
                DropdownMenuItem(
                  value: SortOption.stars,
                  child: Text("Stars"),
                ),
              ],
              onChanged: (sort) => changeSortOrder(sort),
            ),
          ],
        ),
      ),
      
      // Repository list
      ...filteredRepos.map((repo) => GHRepositoryCard(
        owner: repo.owner,
        name: repo.name,
        description: repo.description,
        language: repo.language,
        starCount: repo.starCount,
        forkCount: repo.forkCount,
        lastUpdated: repo.updatedAt,
        starredAt: repo.starredAt, // Show when user starred
        onTap: () => openRepository(repo),
        onUnstar: () => unstarRepository(repo),
      )),
      
      // Empty state
      if (filteredRepos.isEmpty && !isLoading)
        EmptyState(
          icon: Icons.star_border,
          title: hasActiveFilters 
            ? "No repositories match your filters"
            : "No starred repositories",
          subtitle: hasActiveFilters
            ? "Try adjusting your search or filters"
            : "Star repositories to see them here",
          action: hasActiveFilters 
            ? ActionButton(text: "Clear filters", onPressed: clearFilters)
            : ActionButton(text: "Explore repositories", onPressed: explore),
        ),
    ],
  ),
)
```

**Information Display**:
- Total count of starred repositories
- Advanced filtering by language, activity, date starred
- Sort options (recently starred, updated, name, stars)
- Repository cards with starring timestamp
- Quick unstar action on each card
- Empty states for no results or no starred repos
- Search functionality across starred repos

**Design Specifications**:
- Filter chip bar height: 48dp
- Sort dropdown height: 40dp
- Repository card height: 120dp with starred date
- Empty state icon size: 64x64dp
- Unstar button size: 32x32dp
- Search results update: 300ms debounce

**Common Design Patterns Across Screens**:
- Consistent header treatment with actions
- Pull-to-refresh on all list screens
- Search integration where appropriate
- Empty states with helpful messaging
- Loading states with skeleton screens
- Error states with retry options
- Accessibility support throughout
- Responsive layout for different screen sizes

## Standalone UI System Implementation Plan

This implementation plan creates a complete UI system in `lib/src/ui-system/` with example screens and fake data. The system is built independently without integrating to existing app screens. The plan is condensed into 3 focused phases that each deliver substantial, demonstrable functionality.

### Phase 1: Foundation & Core Components
**Deliverable**: Complete design system foundation with component library showcase

**File Structure**:
```
lib/src/ui-system/
├── tokens/gh_tokens.dart
├── theme/gh_theme.dart
├── components/
│   ├── gh_card.dart
│   ├── gh_button.dart
│   ├── gh_chip.dart
│   ├── gh_list_tile.dart
│   ├── gh_search_bar.dart
│   ├── gh_status_badge.dart
│   └── gh_text_field.dart
├── utils/
│   ├── date_formatter.dart
│   ├── number_formatter.dart
│   └── color_utils.dart
└── examples/
    ├── design_tokens_screen.dart
    └── component_catalog_screen.dart
```

**Components to Build**:
1. **Design Tokens & Theme System**
   - GitHub brand colors with Material Design 3 scheme
   - Typography scale (8 text styles)
   - Spacing system (4dp-32dp grid)
   - GitHub semantic colors (success, error, merged, draft)
   - Light/dark theme configuration

2. **Core UI Components**
   - `GHCard` - Elevated card with consistent styling
   - `GHButton` - Primary/secondary buttons with loading states
   - `GHChip` - Filter chips with selection and count badges
   - `GHListTile` - Enhanced list item with GitHub styling
   - `GHSearchBar` - Search input with GitHub design
   - `GHStatusBadge` - Status indicators with semantic colors
   - `GHTextField` - Form input with GitHub styling

3. **Utility Functions**
   - Date formatting (relative: "2 hours ago")
   - Number formatting (1.2k stars, compact notation)
   - Color utilities for programming languages

**Example Screens**:
1. **Design Tokens Screen** - Showcase all design tokens
   - Color palette grid with hex values
   - Typography specimens with all 8 styles
   - Spacing examples with visual measurements
   - Theme switching demonstration

2. **Component Catalog Screen** - Interactive component library
   - All components in different states (enabled/disabled/loading)
   - Interactive examples with tap feedback
   - Size variants and configuration options

**Fake Data Required**:
- Sample text for typography (headlines, body text, labels)
- Button labels ("Star", "Watch", "Fork", "Follow")
- Status examples ("Open", "Closed", "Merged", "Draft")
- Color codes for 10+ programming languages

**Success Criteria**:
- Design tokens screen displays complete token system
- Component catalog shows all components working correctly
- Light/dark theme switching works throughout
- All components use design tokens consistently
- Touch targets meet 48dp accessibility requirements

### Phase 2: GitHub Content Widgets & Layout System  
**Deliverable**: GitHub-specific widgets with layout templates and example screens

**File Structure**:
```
lib/src/ui-system/
├── layouts/
│   ├── gh_screen_template.dart
│   ├── gh_list_template.dart
│   └── gh_content_template.dart
├── widgets/
│   ├── gh_repository_card.dart
│   ├── gh_issue_card.dart
│   ├── gh_user_card.dart
│   ├── gh_file_tree_item.dart
│   ├── gh_entity_header.dart
│   ├── gh_navigation_grid.dart
│   ├── gh_filter_bar.dart
│   ├── gh_code_viewer.dart
│   └── gh_markdown_viewer.dart
├── state_widgets/
│   ├── gh_empty_state.dart
│   ├── gh_loading_indicator.dart
│   └── gh_error_state.dart
└── examples/
    ├── github_widgets_screen.dart
    ├── layout_patterns_screen.dart
    ├── code_content_screen.dart
    └── content_cards_screen.dart
```

**Components to Build**:
1. **Layout Templates**
   - `GHScreenTemplate` - Standard screen with app bar and body
   - `GHListTemplate` - List layout with search, filters, pull-to-refresh
   - `GHContentTemplate` - Content layout with sections

2. **GitHub Content Widgets**
   - `GHRepositoryCard` - Repository with stats, language, description
   - `GHIssueCard` - Issue/PR card with status, labels, metadata
   - `GHUserCard` - User profile card with avatar and stats
   - `GHFileTreeItem` - File/folder item with icons and metadata
   - `GHEntityHeader` - Header for repos, users, organizations
   - `GHNavigationGrid` - Action grid (2x2, 2x3 layouts)
   - `GHFilterBar` - Horizontal scrollable filter chips

3. **Content Viewers**
   - `GHCodeViewer` - Code with syntax highlighting and line numbers
   - `GHMarkdownViewer` - Markdown renderer with GitHub styling

4. **State Widgets**
   - `GHEmptyState` - Empty state with icon, title, action
   - `GHLoadingIndicator` - Loading spinner
   - `GHErrorState` - Error state with retry

**Example Screens**:
1. **GitHub Widgets Screen** - Showcase all GitHub-specific widgets
   - Repository cards with realistic data
   - Issue/PR cards with different statuses
   - User cards with profile information
   - File tree items with various file types

2. **Layout Patterns Screen** - Demonstrate layout templates
   - Basic screen layout example
   - List layout with fake items and pull-to-refresh
   - Content layout with multiple sections

3. **Code Content Screen** - Show content viewers
   - Code viewer with syntax highlighting in multiple languages
   - Markdown viewer with GitHub-style formatting

4. **Content Cards Screen** - Interactive card gallery
   - Repository cards (20+ popular repos)
   - Issue cards with various statuses and labels
   - User cards with realistic profiles

**Fake Data Required**:
- 20+ popular repositories (react, flutter, vscode, kubernetes, etc.)
- User profiles (octocat, torvalds, gaearon, ken, DHH)
- 30+ issues/PRs with realistic titles, labels, statuses
- File structures mimicking real repositories
- Code samples in 5+ languages (Dart, JavaScript, Python, Swift, Go)
- Markdown content (README-style with headers, lists, code blocks)

**Success Criteria**:
- All GitHub widgets display realistic fake data correctly
- Layout templates provide consistent screen structure
- Code viewer shows syntax highlighting for multiple languages
- Markdown renders with proper GitHub styling
- Filter and search widgets demonstrate live functionality
- Pull-to-refresh and infinite scroll work smoothly

### Phase 3: Complete Example Screens & Navigation
**Deliverable**: Full GitHub mobile app screens with navigation and interactions

**File Structure**:
```
lib/src/ui-system/
├── example_screens/
│   ├── home_screen_example.dart
│   ├── user_profile_example.dart
│   ├── repository_details_example.dart
│   ├── starred_repos_example.dart
│   ├── repository_tree_example.dart
│   ├── repository_file_example.dart
│   ├── issues_list_example.dart
│   ├── issue_detail_example.dart
│   ├── pulls_list_example.dart
│   └── pull_detail_example.dart
├── navigation/
│   ├── ui_system_app.dart
│   └── example_routes.dart
├── data/
│   ├── fake_data_service.dart
│   ├── fake_repositories.dart
│   ├── fake_users.dart
│   └── fake_issues.dart
└── main_ui_system.dart
```

**Complete Example Screens**:
1. **Home Screen** - Dashboard with user summary, quick actions, activity feed
2. **User Profile** - Complete profile with tabs (repos, starred, organizations)
3. **Repository Details** - Full repo overview with README, stats, actions
4. **Starred Repositories** - Advanced filtering and search
5. **Repository Tree** - File browser with breadcrumbs
6. **Repository File** - Code viewer with syntax highlighting
7. **Issues List** - Filterable issues with status indicators
8. **Issue Detail** - Complete issue with comments and reactions
9. **Pull Requests List** - PRs with review and CI status
10. **Pull Request Detail** - Complete PR with file changes

**Advanced Features**:
- Complete navigation system between all screens
- Real-time search with debouncing
- Advanced filtering (language, date, status)
- Interactive actions (star, follow, unstar) with optimistic updates
- Pull-to-refresh and infinite scroll
- Empty and error states throughout

**Comprehensive Fake Data**:
- 5+ user profiles with complete information
- 50+ repositories across various categories
- 100+ issues and PRs with realistic content
- Comment threads with multiple participants
- File structures with realistic code content
- Activity feed spanning multiple time periods

**Navigation & Demo App**:
- Standalone app (`main_ui_system.dart`) showcasing the complete system
- Navigation flows connecting all screens
- Deep linking support for all major features
- Smooth transitions and animations

**Success Criteria**:
- Complete GitHub mobile app experience with fake data
- All major user flows work end-to-end
- Advanced features like search, filtering, and actions function correctly
- Navigation feels native with proper back button handling
- Performance is smooth with 60fps interactions
- Empty states and error handling work throughout

## Kiro Specification Creation Guide

Each phase in this implementation plan should be converted into a separate Kiro specification with the following structure:

### Specification Template for Each Phase

```markdown
# [Phase Name] Requirements

## Introduction
This document captures the requirements for the [Phase Name] implementation. This phase delivers [specific deliverables] with [demo/example] functionality using fake data.

## Requirements

### Requirement 1: [Component/Feature Name]
**User Story:** As a developer, I want to [action/goal], so that I can [benefit/outcome].

#### Acceptance Criteria
1. WHEN [condition] THEN the system SHALL [expected behavior]
2. WHEN [condition] THEN the system SHALL [expected behavior]
[Continue with all specific behaviors]

### Requirement 2: [Next Component/Feature]
[Continue pattern for all deliverables in the phase]
```

### Phase-to-Kiro Mapping

1. **Phase 1 → `.kiro/specs/ui-foundation/`** - Design tokens, theme system, and core components
2. **Phase 2 → `.kiro/specs/ui-widgets/`** - GitHub content widgets, layouts, and content viewers  
3. **Phase 3 → `.kiro/specs/ui-examples/`** - Complete example screens with navigation and fake data

### Implementation Guidelines for Code Agent

**File Organization**:
- All code in `lib/src/ui-system/` directory
- No integration with existing app code
- Self-contained with own navigation and fake data
- Standalone demo app (`main_ui_system.dart`)

**Code Generation Patterns**:
- Use StatelessWidget with const constructors where possible
- Implement proper error handling and loading states
- Follow Material Design 3 patterns and accessibility guidelines
- Generate corresponding test files for each component

**Quality Requirements**:
- Run `flutter analyze --fatal-infos --fatal-warnings` after each phase
- Run `dart format .` before completing each phase
- Ensure all example screens work with realistic fake data
- Verify accessibility requirements (48dp touch targets, color contrast)

**Deliverable Focus**:
- Each phase produces substantial, demonstrable functionality
- All components work with comprehensive fake data
- Example screens show complete GitHub mobile app experience
- Components are reusable and follow consistent design patterns
- Standalone system that can be run and tested independently

This condensed 3-phase approach ensures rapid development of a complete UI system that demonstrates the full GitHub mobile app experience without any dependencies on existing code.
## Design
 System UAT Approach

### Overview

The GH3 design system includes a dedicated User Acceptance Testing (UAT) approach that enables stakeholders and developers to easily review and validate the design system components across multiple platforms. This approach uses a standalone UAT application that showcases all design tokens, components, and patterns.

### UAT Entry Point

**File**: `lib/main_ui_system_uat.dart`

This dedicated entry point provides a complete Material Design 3 experience with GitHub theming, specifically designed for stakeholder review and user acceptance testing.

#### Key Features:
- **Cross-Platform Compatibility**: Works seamlessly on web, iOS, and Android
- **Interactive Theme Switching**: Live light/dark mode toggle for comprehensive testing
- **Complete Component Showcase**: All design system components in various states
- **Realistic Fake Data**: GitHub-appropriate sample data for authentic evaluation
- **Navigation System**: Easy access to all design system areas

### Build Commands for UAT

#### Web Platform (Recommended for Stakeholder Review)
```bash
# Run UAT app on web for easy stakeholder access
flutter run -d chrome --target=lib/main_ui_system_uat.dart

# Build for web deployment
flutter build web --target=lib/main_ui_system_uat.dart
```

#### Mobile Platforms
```bash
# Run on iOS
flutter run -d ios --target=lib/main_ui_system_uat.dart

# Run on Android
flutter run -d android --target=lib/main_ui_system_uat.dart
```

### UAT Application Structure

#### Home Screen (`UATHomeScreen`)
- **Purpose**: Central navigation hub for design system exploration
- **Features**:
  - Theme toggle with visual feedback
  - Navigation cards to major sections
  - Build information and feature highlights
  - Quick action buttons for common tasks

#### Design Tokens Screen (`DesignTokensScreen`)
- **Purpose**: Comprehensive showcase of all design tokens
- **Content**:
  - GitHub brand colors with hex values
  - Semantic colors with usage context
  - Typography scale with specimens
  - Spacing system with visual measurements
  - Programming language colors
  - Border radius and elevation examples

#### Component Catalog Screen (`ComponentCatalogScreen`)
- **Purpose**: Interactive demonstration of all UI components
- **Content**:
  - All 7 core components (GHCard, GHButton, GHChip, etc.)
  - Multiple states (enabled, disabled, loading)
  - Interactive examples with feedback
  - Realistic GitHub-style content

### Rationale for Web Platform Focus

The UAT approach prioritizes web platform deployment for several strategic reasons:

1. **Accessibility**: Stakeholders can access the design system from any device with a browser
2. **No Installation Required**: Eliminates barriers for non-technical reviewers
3. **Easy Sharing**: Simple URL sharing for distributed teams
4. **Consistent Experience**: Material Design 3 renders consistently across browsers
5. **Development Velocity**: Faster iteration cycles for design reviews

### UAT Workflow

#### For Stakeholders:
1. Access the UAT web application via provided URL
2. Use theme toggle to test both light and dark modes
3. Navigate through design tokens to review visual foundations
4. Interact with component catalog to test functionality
5. Provide feedback on design consistency and usability

#### For Developers:
1. Run UAT application locally during development
2. Test components across different platforms
3. Validate design token implementation
4. Verify accessibility compliance
5. Document any issues or improvements needed

### Quality Assurance

The UAT approach includes comprehensive testing to ensure reliability:

- **Unit Tests**: All utility functions and core logic
- **Widget Tests**: Individual component functionality
- **Integration Tests**: Cross-component interactions and theme switching
- **Accessibility Tests**: Touch target sizes and contrast ratios
- **Cross-Platform Tests**: Consistent behavior across platforms

### Deployment Strategy

#### Development Phase:
- Local testing using `flutter run` commands
- Continuous integration testing on all platforms
- Regular stakeholder reviews using web deployment

#### UAT Phase:
- Dedicated web deployment for stakeholder access
- Mobile builds for device-specific testing
- Feedback collection and iteration cycles

#### Production Integration:
- Design system components integrated into main application
- UAT application maintained for ongoing design reviews
- Documentation updates based on UAT feedback

### Maintenance and Updates

The UAT application is maintained alongside the main design system:

1. **Automatic Updates**: New components automatically appear in catalog
2. **Version Tracking**: Build information displays current version
3. **Fake Data Management**: Centralized provider for realistic content
4. **Documentation Sync**: UAT reflects current design system state

### Success Metrics

UAT effectiveness is measured by:

- **Stakeholder Engagement**: Time spent reviewing components
- **Feedback Quality**: Specific, actionable design improvements
- **Issue Detection**: Problems identified before production integration
- **Approval Velocity**: Faster design system acceptance cycles
- **Cross-Platform Consistency**: Uniform experience across platforms

### Future Enhancements

Planned improvements to the UAT approach:

1. **Interactive Prototyping**: Component configuration panels
2. **Export Capabilities**: Design token export for design tools
3. **Usage Analytics**: Component interaction tracking
4. **Collaborative Features**: Inline commenting and feedback
5. **Automated Testing**: Visual regression testing integration

This UAT approach ensures that the GH3 design system meets stakeholder expectations while maintaining technical excellence and cross-platform compatibility.