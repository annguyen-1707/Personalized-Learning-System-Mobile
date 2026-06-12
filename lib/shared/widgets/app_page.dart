import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/section_header.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.children,
    this.onRefresh,
    this.bottomPadding,
    super.key,
  });

  final List<Widget> children;
  final RefreshCallback? onRefresh;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 92.h),
      children: children,
    );

    if (onRefresh == null) {
      return content;
    }

    return RefreshIndicator(onRefresh: onRefresh!, child: content);
  }
}

class AppSection extends StatelessWidget { // section có tiêu đề dùng chung cho mọi app
  const AppSection({
    required this.title,
    required this.children,
    this.action,
    super.key,
  });

  final String title;
  final Widget? action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title, action: action),
        ...children,
      ],
    );
  }
}

class AppPagePadding extends StatelessWidget { // padding dùng chung cho mọi app
  const AppPagePadding({required this.child, this.vertical = 8, super.key});

  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: vertical.h),
      child: child,
    );
  }
}
