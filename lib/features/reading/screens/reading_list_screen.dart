import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/config/app_config.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/reading/models/reading_content.dart';
import 'package:personalized_learning_system_mobile/features/reading/screens/reading_detail_screen.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

class ReadingListScreen extends StatefulWidget {
  const ReadingListScreen({super.key});

  @override
  State<ReadingListScreen> createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateScope.read(context).reading.loadContents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppStateScope.watch(context).reading;
    return Scaffold(
      appBar: AppBar(title: const Text('Luyện đọc')),
      body: AppPage(
        onRefresh: provider.loadContents,
        children: [
          AppSection(
            title: 'Bài đọc',
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
                    child: Text('Máy chủ chưa có bài đọc công khai.'),
                  ),
                )
              else
                ...provider.contents.asMap().entries.map(
                  (entry) => _ReadingTile(content: entry.value)
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

class _ReadingTile extends StatelessWidget {
  const _ReadingTile({required this.content});

  final ReadingContent content;

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
                builder: (_) => ReadingDetailScreen(content: content),
              ),
            );
          },
          child: ShadCard(
            padding: EdgeInsets.zero,
            radius: BorderRadius.circular(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.r),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 8,
                    child: _ReadingImage(imageUrl: content.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ShadBadge.secondary(
                            child: Text(_categoryLabel(content.category)),
                          ),
                          SizedBox(width: 8.w),
                          ShadBadge.outline(child: Text(content.level)),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 20.sp,
                            color: AppTheme.muted,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        content.scriptVietnamese,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppTheme.muted, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    return switch (category.toUpperCase()) {
      'TECHNOLOGY' => 'Công nghệ',
      'SCIENCE' => 'Khoa học',
      'HEALTH' => 'Sức khỏe',
      'BUSINESS' => 'Kinh doanh',
      'ENVIRONMENT' => 'Môi trường',
      'POLITICS' => 'Chính trị',
      'SPORTS' => 'Thể thao',
      'ENTERTAINMENT' => 'Giải trí',
      'TRAVEL' => 'Du lịch',
      _ => 'Giáo dục',
    };
  }
}

class _ReadingImage extends StatelessWidget {
  const _ReadingImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _placeholder();
    }
    return Image.network(
      _absoluteImageUrl(imageUrl),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.primary.withValues(alpha: .1),
      alignment: Alignment.center,
      child: Icon(
        Icons.newspaper_rounded,
        color: AppTheme.primary,
        size: 48.sp,
      ),
    );
  }

  String _absoluteImageUrl(String value) {
    final rawValue = value.trim().replaceAll('\\', '/');
    final base = Uri.parse(AppConfig.defaultBaseUrl);
    final uri = Uri.tryParse(rawValue);
    if (uri != null && uri.hasScheme) {
      if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
        return uri.replace(host: base.host, port: base.port).toString();
      }
      return uri.toString();
    }
    final path = rawValue.startsWith('/')
        ? rawValue
        : rawValue.contains('/')
        ? '/$rawValue'
        : '/images/content_reading/$rawValue';
    return base.replace(path: path).toString();
  }
}
