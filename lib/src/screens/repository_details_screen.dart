import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../viewmodels/repository_details_viewmodel.dart';

class RepositoryDetailsScreen extends StatefulWidget {
  final String login;
  final String repo;
  final RepositoryDetailsViewModel viewModel;

  const RepositoryDetailsScreen({
    super.key,
    required this.login,
    required this.repo,
    required this.viewModel,
  });

  @override
  State<RepositoryDetailsScreen> createState() =>
      _RepositoryDetailsScreenState();
}

class _RepositoryDetailsScreenState extends State<RepositoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.refresh();
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.login}/${widget.repo}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          if (widget.viewModel.repository?.htmlUrl != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () =>
                  _copyToClipboard(widget.viewModel.repository!.htmlUrl),
              tooltip: 'Copy repository URL',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.viewModel.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repository Header Card
              _buildRepositoryHeaderCard(),
              const SizedBox(height: 16),

              // Repository Information Card
              _buildRepositoryInfoCard(),
              const SizedBox(height: 16),

              // README Card
              _buildReadmeCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepositoryHeaderCard() {
    final repository = widget.viewModel.repository;
    final isLoading = widget.viewModel.isLoadingRepository;
    final error = widget.viewModel.repositoryError;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (error != null)
              _buildErrorCard(error, widget.viewModel.clearRepositoryError)
            else ...[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: repository?.owner.avatarUrl != null
                        ? NetworkImage(repository!.owner.avatarUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (_, _) {},
                    child:
                        repository?.owner.avatarUrl == null ||
                            repository!.owner.avatarUrl.isEmpty
                        ? const Icon(Icons.account_circle, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repository?.owner.login ?? widget.login,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          repository?.name ?? widget.repo,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (repository?.private == true)
                    const Icon(Icons.lock, color: Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Text(
                  'Loading repository details...',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
              else if (repository?.description != null &&
                  repository!.description!.isNotEmpty)
                Text(
                  repository.description!,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              if (repository?.language != null &&
                  repository!.language!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getLanguageColor(repository.language!),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      repository.language!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoryInfoCard() {
    final repository = widget.viewModel.repository;
    final isLoading = widget.viewModel.isLoadingRepository;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repository Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.link,
              'Repository URL',
              repository?.htmlUrl ??
                  'https://github.com/${widget.login}/${widget.repo}',
              copyable: true,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.star,
              'Stars',
              isLoading
                  ? 'Loading...'
                  : _formatNumber(repository?.stargazersCount ?? 0),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.fork_right,
              'Forks',
              isLoading
                  ? 'Loading...'
                  : _formatNumber(repository?.forksCount ?? 0),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.bug_report,
              'Issues',
              isLoading
                  ? 'Loading...'
                  : _formatNumber(repository?.openIssuesCount ?? 0),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.visibility,
              'Watchers',
              isLoading
                  ? 'Loading...'
                  : _formatNumber(repository?.watchersCount ?? 0),
            ),
            if (repository?.size != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.storage,
                'Size',
                '${_formatSize(repository!.size)} KB',
              ),
            ],
            if (repository?.defaultBranch != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.account_tree,
                'Default Branch',
                repository!.defaultBranch,
              ),
            ],
            if (repository?.createdAt != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                'Created',
                _formatDate(repository!.createdAt),
              ),
            ],
            if (repository?.updatedAt != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.update,
                'Updated',
                _formatDate(repository!.updatedAt),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadmeCard() {
    final isLoading = widget.viewModel.isLoadingReadme;
    final error = widget.viewModel.readmeError;
    final readmeContent = widget.viewModel.readmeContent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'README',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (error != null)
              _buildErrorCard(error, widget.viewModel.clearReadmeError)
            else if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (readmeContent != null && readmeContent.isNotEmpty)
              Container(
                constraints: const BoxConstraints(minHeight: 200),
                child: MarkdownBody(
                  data: readmeContent,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 14, height: 1.5),
                    h1: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    code: TextStyle(
                      backgroundColor: Colors.grey[100],
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No README available',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error, VoidCallback onDismiss) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error, style: TextStyle(color: Colors.red.shade700)),
          ),
          TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool copyable = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(
          child: GestureDetector(
            onTap: copyable ? () => _copyToClipboard(value) : null,
            child: Text(
              value,
              style: TextStyle(
                color: copyable ? Colors.blue : Colors.grey,
                decoration: copyable ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
        if (copyable)
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () => _copyToClipboard(value),
            tooltip: 'Copy to clipboard',
          ),
      ],
    );
  }

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Colors.blue;
      case 'javascript':
        return Colors.yellow;
      case 'typescript':
        return Colors.blue[700]!;
      case 'python':
        return Colors.green;
      case 'java':
        return Colors.orange;
      case 'swift':
        return Colors.orange[700]!;
      case 'kotlin':
        return Colors.purple;
      case 'go':
        return Colors.cyan;
      case 'rust':
        return Colors.brown;
      case 'c++':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatSize(int sizeInKB) {
    if (sizeInKB >= 1024 * 1024) {
      return '${(sizeInKB / (1024 * 1024)).toStringAsFixed(1)} GB';
    } else if (sizeInKB >= 1024) {
      return '${(sizeInKB / 1024).toStringAsFixed(1)} MB';
    }
    return sizeInKB.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
