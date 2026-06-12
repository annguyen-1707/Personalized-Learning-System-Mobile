import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/listening/models/listening_content.dart';
import 'package:personalized_learning_system_mobile/features/listening/screens/listening_detail_screen.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

class ListeningListScreen extends StatefulWidget {
  const ListeningListScreen({super.key});

  @override
  State<ListeningListScreen> createState() => _ListeningListScreenState();
}

class _ListeningListScreenState extends State<ListeningListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = AppStateScope.read(context).listening;
      if (provider.contents.isEmpty) {
        provider.loadContents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).listening;
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện nghe')),
      body: AppPage(
        onRefresh: provider.loadContents,
        children: [
          AppSection(
            title: 'Bài nghe',
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
              else
                ...provider.contents.asMap().entries.map(
                  (entry) => _ListeningTile(content: entry.value)
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
}

class _ListeningTile extends StatelessWidget {
  const _ListeningTile({required this.content});

  final ListeningContent content;

  @override
  Widget build(BuildContext context) {
    return AppPagePadding(
      vertical: 7,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ListeningDetailScreen(content: content),
              ),
            );
          },
          child: ShadCard(
            padding: EdgeInsets.all(16.w),
            radius: BorderRadius.circular(18.r),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: AppTheme.indigo.withValues(alpha: .11),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.headphones_rounded,
                    color: AppTheme.indigo,
                    size: 27.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 7.h),
                      Wrap(
                        spacing: 7.w,
                        runSpacing: 5.h,
                        children: [
                          ShadBadge.outline(child: Text(content.level)),
                          ShadBadge.secondary(
                            child: Text(_categoryLabel(content.category)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    return switch (category.toUpperCase()) {
      'NEWS' => 'Tin tức',
      'STORY' => 'Truyện',
      'INTERVIEW' => 'Phỏng vấn',
      'PODCAST' => 'Podcast',
      'DISCUSSION' => 'Thảo luận',
      'ANNOUNCEMENT' => 'Thông báo',
      'INSTRUCTION' => 'Hướng dẫn',
      'DEBATE' => 'Tranh luận',
      'REPORT' => 'Báo cáo',
      _ => 'Hội thoại',
    };
  }
}
