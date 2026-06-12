import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/speaking/models/speaking_content.dart';
import 'package:personalized_learning_system_mobile/features/speaking/screens/speaking_detail_screen.dart';
import 'package:personalized_learning_system_mobile/features/speaking/widgets/speaking_content_tile.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';

class SpeakingListScreen extends StatefulWidget {
  const SpeakingListScreen({super.key});

  @override
  State<SpeakingListScreen> createState() => _SpeakingListScreenState();
}

class _SpeakingListScreenState extends State<SpeakingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = AppStateScope.read(context).speaking;
      if (provider.contents.isEmpty) {
        provider.loadContents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).speaking;
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện nói')),
      body: AppPage(
        onRefresh: provider.loadContents,
        children: [
          AppSection(
            title: 'Bài luyện nói',
            action: provider.contents.isEmpty
                ? null
                : Text('${provider.contents.length} bài'),
            children: [
              if (provider.isLoading && provider.contents.isEmpty)
                const AppPagePadding(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.errorMessage != null &&
                  provider.contents.isEmpty)
                AppPagePadding(
                  child: Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.coral),
                  ),
                )
              else if (provider.contents.isEmpty)
                const AppPagePadding(
                  child: Center(
                    child: Text('Máy chủ chưa có bài luyện nói công khai.'),
                  ),
                )
              else
                ...provider.contents.asMap().entries.map(
                  (entry) =>
                      SpeakingContentTile(
                            content: entry.value,
                            onTap: () => _openContent(entry.value),
                          )
                          .animate(delay: (entry.key * 60).ms)
                          .fadeIn(duration: 320.ms)
                          .slideY(begin: .04),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openContent(SpeakingContent content) async {
    final user = AppStateScope.read(context).auth.user;
    if (user?.isVip != true) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.workspace_premium_rounded,
            color: AppTheme.amber,
          ),
          title: const Text('Tính năng VIP'),
          content: const Text(
            'Luyện nói và chấm phát âm bằng AI chỉ dành cho thành viên Premium. '
            'Bạn có thể nâng cấp gói trong phần Hồ sơ.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      );
      return;
    }
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SpeakingDetailScreen(content: content),
      ),
    );
  }
}
