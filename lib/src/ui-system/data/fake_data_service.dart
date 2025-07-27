import 'dart:math';
import '../components/gh_status_badge.dart';
import '../widgets/gh_file_tree_item.dart';

/// Centralized fake data service for the UI system.
///
/// This service provides realistic fake data for all GitHub widgets
/// including repositories, users, issues, and files. All data is
/// generated to match real GitHub usage patterns.
class FakeDataService {
  static final FakeDataService _instance = FakeDataService._internal();
  factory FakeDataService() => _instance;
  FakeDataService._internal();

  final Random _random = Random();

  /// Get a list of fake repositories
  List<FakeRepository> getRepositories({int count = 20}) {
    return _repositories.take(count).toList();
  }

  /// Get a list of fake users
  List<FakeUser> getUsers({int count = 20}) {
    return _users.take(count).toList();
  }

  /// Get a list of fake issues
  List<FakeIssue> getIssues({int count = 30}) {
    return _issues.take(count).toList();
  }

  /// Get a list of fake files
  List<FakeFile> getFiles({int count = 20}) {
    return _files.take(count).toList();
  }

  /// Search repositories by name or description
  List<FakeRepository> searchRepositories(String query) {
    if (query.isEmpty) return getRepositories();

    final lowerQuery = query.toLowerCase();
    return _repositories
        .where(
          (repo) =>
              repo.name.toLowerCase().contains(lowerQuery) ||
              repo.description.toLowerCase().contains(lowerQuery) ||
              repo.owner.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Search users by name or username
  List<FakeUser> searchUsers(String query) {
    if (query.isEmpty) return getUsers();

    final lowerQuery = query.toLowerCase();
    return _users
        .where(
          (user) =>
              user.login.toLowerCase().contains(lowerQuery) ||
              (user.name?.toLowerCase().contains(lowerQuery) ?? false) ||
              (user.bio?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  /// Search issues by title
  List<FakeIssue> searchIssues(String query) {
    if (query.isEmpty) return getIssues();

    final lowerQuery = query.toLowerCase();
    return _issues
        .where((issue) => issue.title.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filter repositories by language
  List<FakeRepository> filterRepositoriesByLanguage(String language) {
    return _repositories.where((repo) => repo.language == language).toList();
  }

  /// Filter issues by status
  List<FakeIssue> filterIssuesByStatus(GHStatus status) {
    return _issues.where((issue) => issue.status == status).toList();
  }

  /// Get random repository
  FakeRepository getRandomRepository() {
    return _repositories[_random.nextInt(_repositories.length)];
  }

  /// Get random user
  FakeUser getRandomUser() {
    return _users[_random.nextInt(_users.length)];
  }

  /// Get random issue
  FakeIssue getRandomIssue() {
    return _issues[_random.nextInt(_issues.length)];
  }

  // Static data collections
  static final List<FakeRepository> _repositories = [
    FakeRepository(
      owner: 'facebook',
      name: 'react',
      description: 'The library for web and native user interfaces',
      language: 'JavaScript',
      starCount: 218000,
      forkCount: 45200,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'flutter',
      name: 'flutter',
      description:
          'Flutter makes it easy and fast to build beautiful apps for mobile and beyond',
      language: 'Dart',
      starCount: 158000,
      forkCount: 25800,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'microsoft',
      name: 'vscode',
      description: 'Visual Studio Code',
      language: 'TypeScript',
      starCount: 152000,
      forkCount: 26900,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'kubernetes',
      name: 'kubernetes',
      description: 'Production-Grade Container Scheduling and Management',
      language: 'Go',
      starCount: 104000,
      forkCount: 38200,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'vercel',
      name: 'next.js',
      description: 'The React Framework',
      language: 'JavaScript',
      starCount: 115000,
      forkCount: 25100,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'nodejs',
      name: 'node',
      description: 'Node.js JavaScript runtime',
      language: 'JavaScript',
      starCount: 98500,
      forkCount: 26800,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'vuejs',
      name: 'vue',
      description: 'The Progressive JavaScript Framework',
      language: 'TypeScript',
      starCount: 205000,
      forkCount: 33600,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 8)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'angular',
      name: 'angular',
      description: 'The modern web developer\'s platform',
      language: 'TypeScript',
      starCount: 92000,
      forkCount: 24300,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'tensorflow',
      name: 'tensorflow',
      description: 'An Open Source Machine Learning Framework for Everyone',
      language: 'C++',
      starCount: 180000,
      forkCount: 88200,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'pytorch',
      name: 'pytorch',
      description: 'Tensors and Dynamic neural networks in Python',
      language: 'Python',
      starCount: 75000,
      forkCount: 20400,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'rust-lang',
      name: 'rust',
      description:
          'Empowering everyone to build reliable and efficient software',
      language: 'Rust',
      starCount: 89000,
      forkCount: 11500,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 7)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'golang',
      name: 'go',
      description: 'The Go programming language',
      language: 'Go',
      starCount: 118000,
      forkCount: 17200,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 9)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'apple',
      name: 'swift',
      description: 'The Swift Programming Language',
      language: 'C++',
      starCount: 65000,
      forkCount: 10400,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 11)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'JetBrains',
      name: 'kotlin',
      description: 'The Kotlin Programming Language',
      language: 'Kotlin',
      starCount: 47000,
      forkCount: 5800,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 14)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'rails',
      name: 'rails',
      description: 'Ruby on Rails',
      language: 'Ruby',
      starCount: 54000,
      forkCount: 21200,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 16)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'laravel',
      name: 'laravel',
      description: 'A PHP framework for web artisans',
      language: 'PHP',
      starCount: 76000,
      forkCount: 24600,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 18)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'django',
      name: 'django',
      description: 'The Web framework for perfectionists with deadlines',
      language: 'Python',
      starCount: 75000,
      forkCount: 30800,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 20)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'spring-projects',
      name: 'spring-boot',
      description: 'Spring Boot',
      language: 'Java',
      starCount: 71000,
      forkCount: 39800,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 22)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'dotnet',
      name: 'core',
      description:
          '.NET is a cross-platform runtime for cloud, mobile, desktop, and IoT apps',
      language: 'C#',
      starCount: 19000,
      forkCount: 4900,
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'elastic',
      name: 'elasticsearch',
      description: 'Free and Open, Distributed, RESTful Search Engine',
      language: 'Java',
      starCount: 67000,
      forkCount: 24100,
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'redis',
      name: 'redis',
      description: 'Redis is an in-memory database that persists on disk',
      language: 'C',
      starCount: 63000,
      forkCount: 23200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'mongodb',
      name: 'mongo',
      description: 'The MongoDB Database',
      language: 'C++',
      starCount: 25000,
      forkCount: 5600,
      lastUpdated: DateTime.now().subtract(const Duration(days: 4)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'postgres',
      name: 'postgres',
      description: 'Mirror of the official PostgreSQL GIT repository',
      language: 'C',
      starCount: 14000,
      forkCount: 4200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'docker',
      name: 'docker-ce',
      description: 'Docker CE',
      language: 'Go',
      starCount: 6000,
      forkCount: 1100,
      lastUpdated: DateTime.now().subtract(const Duration(days: 6)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'hashicorp',
      name: 'terraform',
      description:
          'Terraform enables you to safely and predictably create, change, and improve infrastructure',
      language: 'Go',
      starCount: 40000,
      forkCount: 9200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'ansible',
      name: 'ansible',
      description: 'Ansible is a radically simple IT automation platform',
      language: 'Python',
      starCount: 59000,
      forkCount: 23800,
      lastUpdated: DateTime.now().subtract(const Duration(days: 8)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'grafana',
      name: 'grafana',
      description:
          'The open and composable observability and data visualization platform',
      language: 'TypeScript',
      starCount: 58000,
      forkCount: 11600,
      lastUpdated: DateTime.now().subtract(const Duration(days: 9)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'prometheus',
      name: 'prometheus',
      description: 'The Prometheus monitoring system and time series database',
      language: 'Go',
      starCount: 52000,
      forkCount: 8900,
      lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'apache',
      name: 'kafka',
      description: 'Mirror of Apache Kafka',
      language: 'Java',
      starCount: 27000,
      forkCount: 13400,
      lastUpdated: DateTime.now().subtract(const Duration(days: 11)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'apache',
      name: 'spark',
      description:
          'Apache Spark - A unified analytics engine for large-scale data processing',
      language: 'Scala',
      starCount: 37000,
      forkCount: 27800,
      lastUpdated: DateTime.now().subtract(const Duration(days: 12)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'jekyll',
      name: 'jekyll',
      description: 'Jekyll is a blog-aware static site generator in Ruby',
      language: 'Ruby',
      starCount: 47000,
      forkCount: 10200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 13)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'gatsbyjs',
      name: 'gatsby',
      description: 'The fastest frontend for the headless web',
      language: 'JavaScript',
      starCount: 55000,
      forkCount: 10600,
      lastUpdated: DateTime.now().subtract(const Duration(days: 14)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'nuxt',
      name: 'nuxt.js',
      description: 'The Intuitive Vue Framework',
      language: 'JavaScript',
      starCount: 51000,
      forkCount: 4600,
      lastUpdated: DateTime.now().subtract(const Duration(days: 15)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'sveltejs',
      name: 'svelte',
      description: 'Cybernetically enhanced web apps',
      language: 'JavaScript',
      starCount: 75000,
      forkCount: 3900,
      lastUpdated: DateTime.now().subtract(const Duration(days: 16)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'remix-run',
      name: 'remix',
      description:
          'Build Better Websites. Create modern, resilient user experiences with web fundamentals',
      language: 'TypeScript',
      starCount: 27000,
      forkCount: 2300,
      lastUpdated: DateTime.now().subtract(const Duration(days: 17)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'solidjs',
      name: 'solid',
      description:
          'A declarative, efficient, and flexible JavaScript library for building user interfaces',
      language: 'TypeScript',
      starCount: 30000,
      forkCount: 850,
      lastUpdated: DateTime.now().subtract(const Duration(days: 18)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'qwikdev',
      name: 'qwik',
      description:
          'The HTML-first framework. Instant apps of any size with ~ 1kb JS',
      language: 'TypeScript',
      starCount: 19000,
      forkCount: 1200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 19)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'astro-build',
      name: 'astro',
      description:
          'The web framework that scales with you — Build fast content sites, powerful web applications, dynamic server APIs, and everything in-between',
      language: 'TypeScript',
      starCount: 42000,
      forkCount: 2200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 20)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'vitejs',
      name: 'vite',
      description: 'Next generation frontend tooling. It\'s fast!',
      language: 'TypeScript',
      starCount: 64000,
      forkCount: 5700,
      lastUpdated: DateTime.now().subtract(const Duration(days: 21)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'webpack',
      name: 'webpack',
      description: 'A bundler for javascript and friends',
      language: 'JavaScript',
      starCount: 64000,
      forkCount: 8700,
      lastUpdated: DateTime.now().subtract(const Duration(days: 22)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'rollup',
      name: 'rollup',
      description: 'Next-generation ES module bundler',
      language: 'JavaScript',
      starCount: 24000,
      forkCount: 1500,
      lastUpdated: DateTime.now().subtract(const Duration(days: 23)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'parcel-bundler',
      name: 'parcel',
      description: 'The zero configuration build tool for the web',
      language: 'JavaScript',
      starCount: 43000,
      forkCount: 2200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 24)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'esbuild',
      name: 'esbuild',
      description: 'An extremely fast JavaScript and CSS bundler and minifier',
      language: 'Go',
      starCount: 37000,
      forkCount: 1100,
      lastUpdated: DateTime.now().subtract(const Duration(days: 25)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'swc-project',
      name: 'swc',
      description: 'Rust-based platform for the Web',
      language: 'Rust',
      starCount: 29000,
      forkCount: 1100,
      lastUpdated: DateTime.now().subtract(const Duration(days: 26)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'rome',
      name: 'tools',
      description:
          'Unified developer tools for JavaScript, TypeScript, and the web',
      language: 'Rust',
      starCount: 23000,
      forkCount: 660,
      lastUpdated: DateTime.now().subtract(const Duration(days: 27)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'denoland',
      name: 'deno',
      description: 'A modern runtime for JavaScript and TypeScript',
      language: 'Rust',
      starCount: 92000,
      forkCount: 5100,
      lastUpdated: DateTime.now().subtract(const Duration(days: 28)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'oven-sh',
      name: 'bun',
      description:
          'Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one',
      language: 'Zig',
      starCount: 68000,
      forkCount: 2400,
      lastUpdated: DateTime.now().subtract(const Duration(days: 29)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'tauri-apps',
      name: 'tauri',
      description:
          'Build smaller, faster, and more secure desktop applications with a web frontend',
      language: 'Rust',
      starCount: 75000,
      forkCount: 2200,
      lastUpdated: DateTime.now().subtract(const Duration(days: 30)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'electron',
      name: 'electron',
      description:
          'Build cross-platform desktop apps with JavaScript, HTML, and CSS',
      language: 'C++',
      starCount: 111000,
      forkCount: 14900,
      lastUpdated: DateTime.now().subtract(const Duration(days: 31)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'microsoft',
      name: 'playwright',
      description: 'Playwright is a framework for Web Testing and Automation',
      language: 'TypeScript',
      starCount: 61000,
      forkCount: 3300,
      lastUpdated: DateTime.now().subtract(const Duration(days: 32)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'puppeteer',
      name: 'puppeteer',
      description: 'Headless Chrome Node.js API',
      language: 'TypeScript',
      starCount: 86000,
      forkCount: 9000,
      lastUpdated: DateTime.now().subtract(const Duration(days: 33)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'cypress-io',
      name: 'cypress',
      description:
          'Fast, easy and reliable testing for anything that runs in a browser',
      language: 'JavaScript',
      starCount: 45000,
      forkCount: 3000,
      lastUpdated: DateTime.now().subtract(const Duration(days: 34)),
      isPrivate: false,
    ),
    FakeRepository(
      owner: 'SeleniumHQ',
      name: 'selenium',
      description: 'A browser automation framework and ecosystem',
      language: 'Java',
      starCount: 28000,
      forkCount: 8000,
      lastUpdated: DateTime.now().subtract(const Duration(days: 35)),
      isPrivate: false,
    ),
  ];

  static final List<FakeUser> _users = [
    FakeUser(
      login: 'octocat',
      name: 'The Octocat',
      bio: 'GitHub mascot and friendly neighborhood cat',
      avatarUrl: 'https://github.com/octocat.png',
      repositoryCount: 8,
      followerCount: 4200,
      followingCount: 9,
    ),
    FakeUser(
      login: 'torvalds',
      name: 'Linus Torvalds',
      bio: 'Creator of Linux and Git',
      avatarUrl: 'https://github.com/torvalds.png',
      repositoryCount: 4,
      followerCount: 180000,
      followingCount: 0,
    ),
    FakeUser(
      login: 'gaearon',
      name: 'Dan Abramov',
      bio: 'Working on @reactjs. Co-author of Redux and Create React App.',
      avatarUrl: 'https://github.com/gaearon.png',
      repositoryCount: 67,
      followerCount: 89000,
      followingCount: 171,
    ),
    FakeUser(
      login: 'kentcdodds',
      name: 'Kent C. Dodds',
      bio:
          'Making software development more accessible · Husband, Father, Latter-day Saint, Teacher, OSS, @remix_run',
      avatarUrl: 'https://github.com/kentcdodds.png',
      repositoryCount: 234,
      followerCount: 45000,
      followingCount: 156,
    ),
    FakeUser(
      login: 'sindresorhus',
      name: 'Sindre Sorhus',
      bio:
          'Full-Time Open-Sourcerer ·· Maker of 1000+ npm packages and apps ·· Into Swift and Node.js',
      avatarUrl: 'https://github.com/sindresorhus.png',
      repositoryCount: 1200,
      followerCount: 67000,
      followingCount: 89,
    ),
    FakeUser(
      login: 'addyosmani',
      name: 'Addy Osmani',
      bio: 'Engineering Manager at Google working on Chrome',
      avatarUrl: 'https://github.com/addyosmani.png',
      repositoryCount: 156,
      followerCount: 78000,
      followingCount: 234,
    ),
    FakeUser(
      login: 'tj',
      name: 'TJ Holowaychuk',
      bio:
          'Founder of Apex Software. Creator of Express, Koa, Stylus, Component, and many more',
      avatarUrl: 'https://github.com/tj.png',
      repositoryCount: 289,
      followerCount: 56000,
      followingCount: 12,
    ),
    FakeUser(
      login: 'yyx990803',
      name: 'Evan You',
      bio: 'Creator of @vuejs, previously @meteor & @google',
      avatarUrl: 'https://github.com/yyx990803.png',
      repositoryCount: 78,
      followerCount: 92000,
      followingCount: 45,
    ),
    FakeUser(
      login: 'ryanflorence',
      name: 'Ryan Florence',
      bio:
          'Co-founder of @remix-run, creator of @reach/router (merged into React Router), React Training',
      avatarUrl: 'https://github.com/ryanflorence.png',
      repositoryCount: 145,
      followerCount: 34000,
      followingCount: 123,
    ),
    FakeUser(
      login: 'mjackson',
      name: 'Michael Jackson',
      bio: 'Co-founder of @remix-run. Creator of unpkg and React Router',
      avatarUrl: 'https://github.com/mjackson.png',
      repositoryCount: 89,
      followerCount: 28000,
      followingCount: 67,
    ),
    FakeUser(
      login: 'sebmarkbage',
      name: 'Sebastian Markbåge',
      bio: 'React Core Team at Meta',
      avatarUrl: 'https://github.com/sebmarkbage.png',
      repositoryCount: 34,
      followerCount: 23000,
      followingCount: 89,
    ),
    FakeUser(
      login: 'sophiebits',
      name: 'Sophie Alpert',
      bio: 'Former React team lead at Facebook, now at Humu',
      avatarUrl: 'https://github.com/sophiebits.png',
      repositoryCount: 56,
      followerCount: 19000,
      followingCount: 234,
    ),
    FakeUser(
      login: 'acdlite',
      name: 'Andrew Clark',
      bio: 'React Core Team at Meta',
      avatarUrl: 'https://github.com/acdlite.png',
      repositoryCount: 67,
      followerCount: 15000,
      followingCount: 123,
    ),
    FakeUser(
      login: 'rickhanlonii',
      name: 'Rick Hanlon',
      bio: 'React Core Team at Meta',
      avatarUrl: 'https://github.com/rickhanlonii.png',
      repositoryCount: 45,
      followerCount: 12000,
      followingCount: 78,
    ),
    FakeUser(
      login: 'bvaughn',
      name: 'Brian Vaughn',
      bio: 'React DevTools and Profiler at Meta',
      avatarUrl: 'https://github.com/bvaughn.png',
      repositoryCount: 89,
      followerCount: 18000,
      followingCount: 156,
    ),
    FakeUser(
      login: 'timneutkens',
      name: 'Tim Neutkens',
      bio: 'Co-creator of Next.js at Vercel',
      avatarUrl: 'https://github.com/timneutkens.png',
      repositoryCount: 123,
      followerCount: 25000,
      followingCount: 89,
    ),
    FakeUser(
      login: 'rauchg',
      name: 'Guillermo Rauch',
      bio: 'CEO at Vercel. Creator of Socket.IO, Mongoose, Next.js',
      avatarUrl: 'https://github.com/rauchg.png',
      repositoryCount: 167,
      followerCount: 87000,
      followingCount: 234,
    ),
    FakeUser(
      login: 'zenorocha',
      name: 'Zeno Rocha',
      bio: 'CPO at Resend. Creator of Dracula Theme',
      avatarUrl: 'https://github.com/zenorocha.png',
      repositoryCount: 234,
      followerCount: 43000,
      followingCount: 345,
    ),
    FakeUser(
      login: 'wesbos',
      name: 'Wes Bos',
      bio:
          'Full Stack Developer, Speaker and Teacher. Creator of really good courses',
      avatarUrl: 'https://github.com/wesbos.png',
      repositoryCount: 189,
      followerCount: 56000,
      followingCount: 123,
    ),
    FakeUser(
      login: 'bradtraversy',
      name: 'Brad Traversy',
      bio: 'Web Developer & Instructor at Traversy Media',
      avatarUrl: 'https://github.com/bradtraversy.png',
      repositoryCount: 345,
      followerCount: 78000,
      followingCount: 67,
    ),
    FakeUser(
      login: 'getify',
      name: 'Kyle Simpson',
      bio: 'Author of "You Don\'t Know JS" book series. Open web evangelist',
      avatarUrl: 'https://github.com/getify.png',
      repositoryCount: 123,
      followerCount: 34000,
      followingCount: 89,
    ),
    FakeUser(
      login: 'mdo',
      name: 'Mark Otto',
      bio: 'Co-creator of Bootstrap. Design systems at GitHub',
      avatarUrl: 'https://github.com/mdo.png',
      repositoryCount: 89,
      followerCount: 45000,
      followingCount: 234,
    ),
    FakeUser(
      login: 'fat',
      name: 'Jacob Thornton',
      bio: 'Co-creator of Bootstrap. Design at Medium',
      avatarUrl: 'https://github.com/fat.png',
      repositoryCount: 67,
      followerCount: 23000,
      followingCount: 156,
    ),
    FakeUser(
      login: 'dhh',
      name: 'David Heinemeier Hansson',
      bio: 'Creator of Ruby on Rails, Founder & CTO at Basecamp',
      avatarUrl: 'https://github.com/dhh.png',
      repositoryCount: 45,
      followerCount: 67000,
      followingCount: 23,
    ),
    FakeUser(
      login: 'tenderlove',
      name: 'Aaron Patterson',
      bio: 'Ruby and Rails core team member',
      avatarUrl: 'https://github.com/tenderlove.png',
      repositoryCount: 234,
      followerCount: 34000,
      followingCount: 123,
    ),
  ];

  static final List<FakeIssue> _issues = [
    FakeIssue(
      number: 1234,
      title: 'Add dark mode support to the application',
      status: GHStatus.open,
      labels: ['enhancement', 'ui', 'good first issue'],
      authorLogin: 'johndoe',
      authorAvatarUrl: 'https://github.com/johndoe.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      commentCount: 5,
      assigneeLogin: 'janedoe',
      assigneeAvatarUrl: 'https://github.com/janedoe.png',
    ),
    FakeIssue(
      number: 1235,
      title: 'Fix memory leak in image loading component',
      status: GHStatus.closed,
      labels: ['bug', 'performance'],
      authorLogin: 'alice',
      authorAvatarUrl: 'https://github.com/alice.png',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      commentCount: 12,
    ),
    FakeIssue(
      number: 1236,
      title: 'Implement user authentication with OAuth',
      status: GHStatus.open,
      labels: ['feature', 'authentication', 'security'],
      authorLogin: 'gaearon',
      authorAvatarUrl: 'https://github.com/gaearon.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      commentCount: 8,
      assigneeLogin: 'kentcdodds',
      assigneeAvatarUrl: 'https://github.com/kentcdodds.png',
    ),
    FakeIssue(
      number: 1237,
      title: 'Update dependencies to latest versions',
      status: GHStatus.merged,
      labels: ['dependencies', 'maintenance'],
      authorLogin: 'sindresorhus',
      authorAvatarUrl: 'https://github.com/sindresorhus.png',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      commentCount: 3,
    ),
    FakeIssue(
      number: 1238,
      title: 'Add TypeScript support for better type safety',
      status: GHStatus.draft,
      labels: ['typescript', 'enhancement'],
      authorLogin: 'addyosmani',
      authorAvatarUrl: 'https://github.com/addyosmani.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      commentCount: 15,
      assigneeLogin: 'tj',
      assigneeAvatarUrl: 'https://github.com/tj.png',
    ),
    FakeIssue(
      number: 1239,
      title: 'Performance optimization for large datasets',
      status: GHStatus.open,
      labels: ['performance', 'optimization', 'help wanted'],
      authorLogin: 'yyx990803',
      authorAvatarUrl: 'https://github.com/yyx990803.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      commentCount: 22,
    ),
    FakeIssue(
      number: 1240,
      title: 'Fix responsive design issues on mobile devices',
      status: GHStatus.closed,
      labels: ['bug', 'mobile', 'css'],
      authorLogin: 'ryanflorence',
      authorAvatarUrl: 'https://github.com/ryanflorence.png',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      commentCount: 7,
      assigneeLogin: 'mjackson',
      assigneeAvatarUrl: 'https://github.com/mjackson.png',
    ),
    FakeIssue(
      number: 1241,
      title: 'Add comprehensive unit tests for core components',
      status: GHStatus.open,
      labels: ['testing', 'quality', 'good first issue'],
      authorLogin: 'sebmarkbage',
      authorAvatarUrl: 'https://github.com/sebmarkbage.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      commentCount: 11,
    ),
    FakeIssue(
      number: 1242,
      title: 'Implement real-time notifications system',
      status: GHStatus.open,
      labels: ['feature', 'websockets', 'notifications'],
      authorLogin: 'sophiebits',
      authorAvatarUrl: 'https://github.com/sophiebits.png',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      commentCount: 19,
      assigneeLogin: 'acdlite',
      assigneeAvatarUrl: 'https://github.com/acdlite.png',
    ),
    FakeIssue(
      number: 1243,
      title: 'Security vulnerability in user input validation',
      status: GHStatus.closed,
      labels: ['security', 'critical', 'bug'],
      authorLogin: 'rickhanlonii',
      authorAvatarUrl: 'https://github.com/rickhanlonii.png',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      commentCount: 6,
    ),
    FakeIssue(
      number: 1244,
      title: 'Add internationalization (i18n) support',
      status: GHStatus.draft,
      labels: ['i18n', 'enhancement', 'help wanted'],
      authorLogin: 'bvaughn',
      authorAvatarUrl: 'https://github.com/bvaughn.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      commentCount: 13,
    ),
    FakeIssue(
      number: 1245,
      title: 'Improve accessibility for screen readers',
      status: GHStatus.open,
      labels: ['accessibility', 'a11y', 'enhancement'],
      authorLogin: 'timneutkens',
      authorAvatarUrl: 'https://github.com/timneutkens.png',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      commentCount: 9,
      assigneeLogin: 'rauchg',
      assigneeAvatarUrl: 'https://github.com/rauchg.png',
    ),
    FakeIssue(
      number: 1246,
      title: 'Database migration script fails on production',
      status: GHStatus.open,
      labels: ['bug', 'database', 'production', 'critical'],
      authorLogin: 'zenorocha',
      authorAvatarUrl: 'https://github.com/zenorocha.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      commentCount: 4,
    ),
    FakeIssue(
      number: 1247,
      title: 'Add support for custom themes',
      status: GHStatus.merged,
      labels: ['feature', 'theming', 'ui'],
      authorLogin: 'wesbos',
      authorAvatarUrl: 'https://github.com/wesbos.png',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      commentCount: 16,
    ),
    FakeIssue(
      number: 1248,
      title: 'Optimize bundle size for better performance',
      status: GHStatus.open,
      labels: ['performance', 'bundling', 'optimization'],
      authorLogin: 'bradtraversy',
      authorAvatarUrl: 'https://github.com/bradtraversy.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      commentCount: 8,
    ),
    FakeIssue(
      number: 1249,
      title: 'Add drag and drop functionality',
      status: GHStatus.draft,
      labels: ['feature', 'ui', 'interaction'],
      authorLogin: 'getify',
      authorAvatarUrl: 'https://github.com/getify.png',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      commentCount: 12,
      assigneeLogin: 'mdo',
      assigneeAvatarUrl: 'https://github.com/mdo.png',
    ),
    FakeIssue(
      number: 1250,
      title: 'Fix broken links in documentation',
      status: GHStatus.closed,
      labels: ['documentation', 'bug', 'good first issue'],
      authorLogin: 'fat',
      authorAvatarUrl: 'https://github.com/fat.png',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      commentCount: 2,
    ),
    FakeIssue(
      number: 1251,
      title: 'Implement caching strategy for API responses',
      status: GHStatus.open,
      labels: ['performance', 'caching', 'api'],
      authorLogin: 'dhh',
      authorAvatarUrl: 'https://github.com/dhh.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      commentCount: 14,
    ),
    FakeIssue(
      number: 1252,
      title: 'Add support for keyboard shortcuts',
      status: GHStatus.open,
      labels: ['feature', 'accessibility', 'ux'],
      authorLogin: 'tenderlove',
      authorAvatarUrl: 'https://github.com/tenderlove.png',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      commentCount: 7,
      assigneeLogin: 'octocat',
      assigneeAvatarUrl: 'https://github.com/octocat.png',
    ),
    FakeIssue(
      number: 1253,
      title: 'Memory usage spikes during file uploads',
      status: GHStatus.open,
      labels: ['bug', 'memory', 'file-upload'],
      authorLogin: 'torvalds',
      authorAvatarUrl: 'https://github.com/torvalds.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      commentCount: 18,
    ),
    FakeIssue(
      number: 1254,
      title: 'Add progressive web app (PWA) support',
      status: GHStatus.draft,
      labels: ['pwa', 'enhancement', 'mobile'],
      authorLogin: 'gaearon',
      authorAvatarUrl: 'https://github.com/gaearon.png',
      createdAt: DateTime.now().subtract(const Duration(days: 11)),
      commentCount: 25,
    ),
    FakeIssue(
      number: 1255,
      title: 'Improve error handling and user feedback',
      status: GHStatus.open,
      labels: ['ux', 'error-handling', 'enhancement'],
      authorLogin: 'kentcdodds',
      authorAvatarUrl: 'https://github.com/kentcdodds.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 16)),
      commentCount: 10,
    ),
    FakeIssue(
      number: 1256,
      title: 'Add support for multiple file formats',
      status: GHStatus.merged,
      labels: ['feature', 'file-handling'],
      authorLogin: 'sindresorhus',
      authorAvatarUrl: 'https://github.com/sindresorhus.png',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      commentCount: 6,
    ),
    FakeIssue(
      number: 1257,
      title: 'Fix race condition in async operations',
      status: GHStatus.closed,
      labels: ['bug', 'async', 'concurrency'],
      authorLogin: 'addyosmani',
      authorAvatarUrl: 'https://github.com/addyosmani.png',
      createdAt: DateTime.now().subtract(const Duration(days: 13)),
      commentCount: 9,
    ),
    FakeIssue(
      number: 1258,
      title: 'Add comprehensive API documentation',
      status: GHStatus.open,
      labels: ['documentation', 'api', 'help wanted'],
      authorLogin: 'tj',
      authorAvatarUrl: 'https://github.com/tj.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 22)),
      commentCount: 4,
    ),
    FakeIssue(
      number: 1259,
      title: 'Implement user preferences and settings',
      status: GHStatus.draft,
      labels: ['feature', 'user-settings', 'ui'],
      authorLogin: 'yyx990803',
      authorAvatarUrl: 'https://github.com/yyx990803.png',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      commentCount: 17,
    ),
    FakeIssue(
      number: 1260,
      title: 'Fix CSS layout issues in Safari',
      status: GHStatus.open,
      labels: ['bug', 'css', 'safari', 'browser-specific'],
      authorLogin: 'ryanflorence',
      authorAvatarUrl: 'https://github.com/ryanflorence.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      commentCount: 5,
    ),
    FakeIssue(
      number: 1261,
      title: 'Add automated testing pipeline',
      status: GHStatus.merged,
      labels: ['testing', 'ci-cd', 'automation'],
      authorLogin: 'mjackson',
      authorAvatarUrl: 'https://github.com/mjackson.png',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      commentCount: 11,
    ),
    FakeIssue(
      number: 1262,
      title: 'Improve search functionality with filters',
      status: GHStatus.open,
      labels: ['feature', 'search', 'ui'],
      authorLogin: 'sebmarkbage',
      authorAvatarUrl: 'https://github.com/sebmarkbage.png',
      createdAt: DateTime.now().subtract(const Duration(hours: 26)),
      commentCount: 13,
    ),
    FakeIssue(
      number: 1263,
      title: 'Add support for custom plugins',
      status: GHStatus.draft,
      labels: ['feature', 'plugins', 'extensibility'],
      authorLogin: 'sophiebits',
      authorAvatarUrl: 'https://github.com/sophiebits.png',
      createdAt: DateTime.now().subtract(const Duration(days: 16)),
      commentCount: 21,
    ),
    FakeIssue(
      number: 1264,
      title: 'Fix memory leaks in event listeners',
      status: GHStatus.closed,
      labels: ['bug', 'memory', 'events'],
      authorLogin: 'acdlite',
      authorAvatarUrl: 'https://github.com/acdlite.png',
      createdAt: DateTime.now().subtract(const Duration(days: 17)),
      commentCount: 8,
    ),
  ];

  static final List<FakeFile> _files = [
    FakeFile(
      name: 'README.md',
      type: GHFileType.markdown,
      lastCommitMessage: 'Update installation instructions',
      lastModified: DateTime.now().subtract(const Duration(days: 2)),
      author: 'johndoe',
      size: 2400,
    ),
    FakeFile(
      name: 'src',
      type: GHFileType.directory,
      lastCommitMessage: 'Add new components',
      lastModified: DateTime.now().subtract(const Duration(hours: 5)),
      author: 'janedoe',
    ),
    FakeFile(
      name: 'package.json',
      type: GHFileType.config,
      lastCommitMessage: 'Update dependencies',
      lastModified: DateTime.now().subtract(const Duration(hours: 12)),
      author: 'gaearon',
      size: 1200,
    ),
    FakeFile(
      name: 'lib',
      type: GHFileType.directory,
      lastCommitMessage: 'Refactor core library',
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      author: 'kentcdodds',
    ),
    FakeFile(
      name: 'main.dart',
      type: GHFileType.code,
      lastCommitMessage: 'Fix app initialization',
      lastModified: DateTime.now().subtract(const Duration(hours: 8)),
      author: 'sindresorhus',
      size: 3400,
    ),
    FakeFile(
      name: 'pubspec.yaml',
      type: GHFileType.config,
      lastCommitMessage: 'Add new dependencies',
      lastModified: DateTime.now().subtract(const Duration(days: 3)),
      author: 'addyosmani',
      size: 800,
    ),
    FakeFile(
      name: 'test',
      type: GHFileType.directory,
      lastCommitMessage: 'Add comprehensive tests',
      lastModified: DateTime.now().subtract(const Duration(hours: 18)),
      author: 'tj',
    ),
    FakeFile(
      name: 'docs',
      type: GHFileType.directory,
      lastCommitMessage: 'Update documentation',
      lastModified: DateTime.now().subtract(const Duration(days: 4)),
      author: 'yyx990803',
    ),
    FakeFile(
      name: 'CHANGELOG.md',
      type: GHFileType.markdown,
      lastCommitMessage: 'Update changelog for v2.1.0',
      lastModified: DateTime.now().subtract(const Duration(days: 5)),
      author: 'ryanflorence',
      size: 5600,
    ),
    FakeFile(
      name: 'LICENSE',
      type: GHFileType.file,
      lastCommitMessage: 'Update license year',
      lastModified: DateTime.now().subtract(const Duration(days: 180)),
      author: 'mjackson',
      size: 1100,
    ),
    FakeFile(
      name: '.gitignore',
      type: GHFileType.config,
      lastCommitMessage: 'Add build artifacts to gitignore',
      lastModified: DateTime.now().subtract(const Duration(days: 6)),
      author: 'sebmarkbage',
      size: 450,
    ),
    FakeFile(
      name: 'assets',
      type: GHFileType.directory,
      lastCommitMessage: 'Add new icons and images',
      lastModified: DateTime.now().subtract(const Duration(hours: 24)),
      author: 'sophiebits',
    ),
    FakeFile(
      name: 'config.json',
      type: GHFileType.config,
      lastCommitMessage: 'Update production config',
      lastModified: DateTime.now().subtract(const Duration(days: 7)),
      author: 'acdlite',
      size: 680,
    ),
    FakeFile(
      name: 'scripts',
      type: GHFileType.directory,
      lastCommitMessage: 'Add deployment scripts',
      lastModified: DateTime.now().subtract(const Duration(days: 8)),
      author: 'rickhanlonii',
    ),
    FakeFile(
      name: 'Dockerfile',
      type: GHFileType.config,
      lastCommitMessage: 'Optimize Docker image size',
      lastModified: DateTime.now().subtract(const Duration(days: 9)),
      author: 'bvaughn',
      size: 890,
    ),
    FakeFile(
      name: 'docker-compose.yml',
      type: GHFileType.config,
      lastCommitMessage: 'Add development environment',
      lastModified: DateTime.now().subtract(const Duration(days: 10)),
      author: 'timneutkens',
      size: 1200,
    ),
    FakeFile(
      name: '.github',
      type: GHFileType.directory,
      lastCommitMessage: 'Add GitHub workflows',
      lastModified: DateTime.now().subtract(const Duration(days: 11)),
      author: 'rauchg',
    ),
    FakeFile(
      name: 'tsconfig.json',
      type: GHFileType.config,
      lastCommitMessage: 'Update TypeScript configuration',
      lastModified: DateTime.now().subtract(const Duration(days: 12)),
      author: 'zenorocha',
      size: 560,
    ),
    FakeFile(
      name: 'webpack.config.js',
      type: GHFileType.code,
      lastCommitMessage: 'Optimize build configuration',
      lastModified: DateTime.now().subtract(const Duration(days: 13)),
      author: 'wesbos',
      size: 2300,
    ),
    FakeFile(
      name: 'jest.config.js',
      type: GHFileType.code,
      lastCommitMessage: 'Configure test environment',
      lastModified: DateTime.now().subtract(const Duration(days: 14)),
      author: 'bradtraversy',
      size: 780,
    ),
    FakeFile(
      name: '.eslintrc.js',
      type: GHFileType.config,
      lastCommitMessage: 'Update linting rules',
      lastModified: DateTime.now().subtract(const Duration(days: 15)),
      author: 'getify',
      size: 1400,
    ),
    FakeFile(
      name: '.prettierrc',
      type: GHFileType.config,
      lastCommitMessage: 'Configure code formatting',
      lastModified: DateTime.now().subtract(const Duration(days: 16)),
      author: 'mdo',
      size: 120,
    ),
    FakeFile(
      name: 'components',
      type: GHFileType.directory,
      lastCommitMessage: 'Add reusable UI components',
      lastModified: DateTime.now().subtract(const Duration(hours: 36)),
      author: 'fat',
    ),
    FakeFile(
      name: 'utils',
      type: GHFileType.directory,
      lastCommitMessage: 'Add utility functions',
      lastModified: DateTime.now().subtract(const Duration(days: 17)),
      author: 'dhh',
    ),
    FakeFile(
      name: 'styles',
      type: GHFileType.directory,
      lastCommitMessage: 'Update global styles',
      lastModified: DateTime.now().subtract(const Duration(days: 18)),
      author: 'tenderlove',
    ),
    FakeFile(
      name: 'api',
      type: GHFileType.directory,
      lastCommitMessage: 'Add API endpoints',
      lastModified: DateTime.now().subtract(const Duration(days: 19)),
      author: 'octocat',
    ),
    FakeFile(
      name: 'database',
      type: GHFileType.directory,
      lastCommitMessage: 'Add database migrations',
      lastModified: DateTime.now().subtract(const Duration(days: 20)),
      author: 'torvalds',
    ),
    FakeFile(
      name: 'public',
      type: GHFileType.directory,
      lastCommitMessage: 'Add static assets',
      lastModified: DateTime.now().subtract(const Duration(days: 21)),
      author: 'gaearon',
    ),
    FakeFile(
      name: 'build',
      type: GHFileType.directory,
      lastCommitMessage: 'Update build output',
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      author: 'kentcdodds',
    ),
    FakeFile(
      name: 'node_modules',
      type: GHFileType.directory,
      lastCommitMessage: 'Install dependencies',
      lastModified: DateTime.now().subtract(const Duration(hours: 4)),
      author: 'sindresorhus',
    ),
  ];
}

/// Fake repository data model
class FakeRepository {
  final String owner;
  final String name;
  final String description;
  final String language;
  final int starCount;
  final int forkCount;
  final DateTime lastUpdated;
  final bool isPrivate;

  const FakeRepository({
    required this.owner,
    required this.name,
    required this.description,
    required this.language,
    required this.starCount,
    required this.forkCount,
    required this.lastUpdated,
    this.isPrivate = false,
  });
}

/// Fake user data model
class FakeUser {
  final String login;
  final String? name;
  final String? bio;
  final String avatarUrl;
  final int repositoryCount;
  final int followerCount;
  final int followingCount;

  const FakeUser({
    required this.login,
    this.name,
    this.bio,
    required this.avatarUrl,
    required this.repositoryCount,
    required this.followerCount,
    required this.followingCount,
  });
}

/// Fake issue data model
class FakeIssue {
  final int number;
  final String title;
  final GHStatus status;
  final List<String> labels;
  final String authorLogin;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final int commentCount;
  final String? assigneeLogin;
  final String? assigneeAvatarUrl;

  const FakeIssue({
    required this.number,
    required this.title,
    required this.status,
    this.labels = const [],
    required this.authorLogin,
    this.authorAvatarUrl,
    required this.createdAt,
    this.commentCount = 0,
    this.assigneeLogin,
    this.assigneeAvatarUrl,
  });
}

/// Fake file data model
class FakeFile {
  final String name;
  final GHFileType type;
  final String lastCommitMessage;
  final DateTime lastModified;
  final String author;
  final int? size;

  const FakeFile({
    required this.name,
    required this.type,
    required this.lastCommitMessage,
    required this.lastModified,
    required this.author,
    this.size,
  });
}
