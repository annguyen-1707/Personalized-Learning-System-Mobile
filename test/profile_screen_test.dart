import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/profile/widgets/profile_avatar.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  testWidgets('uses placeholder when avatar path is empty', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => ShadApp.custom(
          theme: AppTheme.shadTheme(),
          appBuilder: (_) => MaterialApp(
            theme: AppTheme.materialTheme(),
            home: const Scaffold(
              body: Center(
                child: ProfileAvatar(
                  avatarUrl: '',
                  fullName: 'Nguyen An',
                  size: Size.square(64),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('N'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
