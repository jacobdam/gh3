class GitHubUser {
  final int id;
  final String login;
  final String? name;
  final String? email;
  final String? bio;
  final String? location;
  final String? company;
  final String? blog;
  final String avatarUrl;
  final String htmlUrl;
  final int publicRepos;
  final int publicGists;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GitHubUser({
    required this.id,
    required this.login,
    this.name,
    this.email,
    this.bio,
    this.location,
    this.company,
    this.blog,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.publicRepos,
    required this.publicGists,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      id: json['id'] as int,
      login: json['login'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      publicRepos: json['public_repos'] as int,
      publicGists: json['public_gists'] as int,
      followers: json['followers'] as int,
      following: json['following'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'name': name,
      'email': email,
      'bio': bio,
      'location': location,
      'company': company,
      'blog': blog,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'public_repos': publicRepos,
      'public_gists': publicGists,
      'followers': followers,
      'following': following,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GitHubUser(id: $id, login: $login, name: $name)';
}
