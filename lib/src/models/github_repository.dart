import 'github_user.dart';

class GitHubRepository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final bool private;
  final String htmlUrl;
  final String cloneUrl;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final int size;
  final String defaultBranch;
  final bool hasIssues;
  final bool hasProjects;
  final bool hasWiki;
  final bool hasPages;
  final bool hasDownloads;
  final bool archived;
  final bool disabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? pushedAt;
  final GitHubUser owner;

  const GitHubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.private,
    required this.htmlUrl,
    required this.cloneUrl,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    required this.size,
    required this.defaultBranch,
    required this.hasIssues,
    required this.hasProjects,
    required this.hasWiki,
    required this.hasPages,
    required this.hasDownloads,
    required this.archived,
    required this.disabled,
    required this.createdAt,
    required this.updatedAt,
    this.pushedAt,
    required this.owner,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      description: json['description'] as String?,
      private: json['private'] as bool,
      htmlUrl: json['html_url'] as String,
      cloneUrl: json['clone_url'] as String,
      language: json['language'] as String?,
      stargazersCount: json['stargazers_count'] as int,
      watchersCount: json['watchers_count'] as int,
      forksCount: json['forks_count'] as int,
      openIssuesCount: json['open_issues_count'] as int,
      size: json['size'] as int,
      defaultBranch: json['default_branch'] as String,
      hasIssues: json['has_issues'] as bool,
      hasProjects: json['has_projects'] as bool,
      hasWiki: json['has_wiki'] as bool,
      hasPages: json['has_pages'] as bool,
      hasDownloads: json['has_downloads'] as bool,
      archived: json['archived'] as bool,
      disabled: json['disabled'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      pushedAt: json['pushed_at'] != null
          ? DateTime.parse(json['pushed_at'] as String)
          : null,
      owner: GitHubUser.fromJson(json['owner'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'private': private,
      'html_url': htmlUrl,
      'clone_url': cloneUrl,
      'language': language,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'size': size,
      'default_branch': defaultBranch,
      'has_issues': hasIssues,
      'has_projects': hasProjects,
      'has_wiki': hasWiki,
      'has_pages': hasPages,
      'has_downloads': hasDownloads,
      'archived': archived,
      'disabled': disabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'pushed_at': pushedAt?.toIso8601String(),
      'owner': owner.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubRepository && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GitHubRepository(id: $id, fullName: $fullName)';
}
