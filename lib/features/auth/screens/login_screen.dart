import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:personalized_learning_system_mobile/shared/widgets/primary_button.dart';
import 'package:shadcn_ui/shadcn_ui.dart'
    hide
        AnimateWidgetExtensions,
        FadeEffectExtensions,
        NumDurationExtensions,
        SlideEffectExtensions;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'annvhe181169@fpt.edu.vn');
  final _passwordController = TextEditingController(text: '12345678');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppStateScope.watch(context).auth;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              const _LoginHero()
                  .animate()
                  .fadeIn(duration: 450.ms)
                  .slideY(begin: .08),
              SizedBox(height: 22.h),
              ShadCard(
                    padding: EdgeInsets.all(18.w),
                    radius: BorderRadius.circular(18.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đăng nhập',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Tiếp tục lộ trình học tiếng Nhật của bạn.',
                          style: TextStyle(
                            color: AppTheme.muted,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        const Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 8.h),
                        ShadInput(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          leading: const Icon(Icons.mail_outline_rounded),
                          placeholder: const Text('student@fuohayo.vn'),
                        ),
                        SizedBox(height: 14.h),
                        const Text(
                          'Mật khẩu',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 8.h),
                        ShadInput(
                          controller: _passwordController,
                          obscureText: true,
                          leading: const Icon(Icons.lock_outline_rounded),
                          placeholder: const Text('Nhập mật khẩu'),
                        ),
                        if (auth.errorMessage != null) ...[
                          SizedBox(height: 12.h),
                          Text(
                            auth.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        SizedBox(height: 18.h),
                        PrimaryButton(
                          label: 'Đăng nhập',
                          icon: Icons.login_rounded,
                          isLoading: auth.isLoading,
                          onPressed: () {
                            auth.login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          },
                        ),
                        // SizedBox(height: 10.h),
                        // ShadButton.outline(
                        //   width: double.infinity,
                        //   height: 50.h,
                        //   onPressed: auth.continueAsDemo,
                        //   leading: const Icon(
                        //     Icons.play_circle_outline_rounded,
                        //   ),
                        //   child: const Text('Dùng thử bằng dữ liệu mẫu'),
                        // ),
                      ],
                    ),
                  )
                  .animate(delay: 120.ms)
                  .fadeIn(duration: 420.ms)
                  .slideY(begin: .08),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: .2),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(Icons.school_rounded, color: Colors.white, size: 32.sp),
          ),
          SizedBox(height: 30.h),
          Text(
            'FU OHAYO',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontSize: 34.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Học tiếng Nhật cá nhân hóa từ N5 đến N1 với flashcard, quiz và luyện kỹ năng.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .84),
              fontSize: 14.sp,
              height: 1.45,
            ),
          ),
          SizedBox(height: 20.h),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(label: 'JLPT N5-N1'),
              _HeroPill(label: 'AI Practice'),
              _HeroPill(label: 'Streak'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: .18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
