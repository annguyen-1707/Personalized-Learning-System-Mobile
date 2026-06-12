import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/flashcard/models/flashcard_item.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/app_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        ScaleEffectExtensions;

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({required this.title, required this.cards, super.key});

  final String title;
  final List<FlashcardItem> cards;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showMeaning = false;

  FlashcardItem? get _currentCard {
    if (widget.cards.isEmpty) {
      return null;
    }
    return widget.cards[_currentIndex % widget.cards.length];
  }

  void _flipCard() {
    setState(() => _showMeaning = !_showMeaning);
  }

  void _nextCard() {
    if (widget.cards.isEmpty) {
      return;
    }
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.cards.length;
      _showMeaning = false;
    });
  }

  void _previousCard() {
    if (widget.cards.isEmpty) {
      return;
    }
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.cards.length) % widget.cards.length;
      _showMeaning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _currentCard;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AppPage(
        children: [
          AppSection(
            title: 'Flashcard',
            action: card == null
                ? null
                : Text('${_currentIndex + 1}/${widget.cards.length}'),
            children: [
              if (card == null)
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: const Center(child: Text('Chưa có flashcard')),
                )
              else
                AppPagePadding(
                      child: Stack(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(24.r),
                            onTap: _flipCard,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: _showMeaning ? pi : 0,
                              ),
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeInOut,
                              builder: (context, value, child) {
                                final isBack = value >= pi / 2;
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(value),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: isBack
                                        ? (Matrix4.identity()..rotateY(pi))
                                        : Matrix4.identity(),
                                    child: Container(
                                      height: 238.h,
                                      padding: EdgeInsets.all(22.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.ink,
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.ink.withValues(
                                              alpha: .14,
                                            ),
                                            blurRadius: 24,
                                            offset: const Offset(0, 14),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ShadBadge.secondary(
                                                child: Text(card.level),
                                              ),
                                              SizedBox(width: 8.w),
                                              ShadBadge.outline(
                                                foregroundColor: Colors.white,
                                                child: Text(card.category),
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.touch_app_rounded,
                                                color: Colors.white.withValues(
                                                  alpha: .7,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  isBack
                                                      ? card.backTitle
                                                      : card.frontTitle,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 40.sp,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  isBack
                                                      ? card.backSubtitle
                                                      : card.frontSubtitle,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: .78),
                                                    fontSize: 16.sp,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 10.w,
                            top: 100.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withValues(
                                alpha: .8,
                              ),
                              child: IconButton(
                                onPressed: _previousCard,
                                icon: const Icon(Icons.navigate_before_rounded),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.w,
                            top: 100.h,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withValues(
                                alpha: .8,
                              ),
                              child: IconButton(
                                onPressed: _nextCard,
                                icon: const Icon(Icons.navigate_next_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 360.ms)
                    .scale(begin: const Offset(.98, .98)),
            ],
          ),
          AppSection(
            title: 'Danh sách ${widget.title.toLowerCase()}',
            children: [
              ...widget.cards.map(
                (item) => AppPagePadding(
                  vertical: 6,
                  child: ShadCard(
                    padding: EdgeInsets.all(14.w),
                    radius: BorderRadius.circular(16.r),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.frontTitle}  ${item.frontSubtitle}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                item.backTitle,
                                style: TextStyle(color: AppTheme.muted),
                              ),
                              if (item.backSubtitle.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  item.backSubtitle,
                                  style: TextStyle(
                                    color: AppTheme.muted.withValues(alpha: .7),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ShadBadge.outline(child: Text(item.level)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
