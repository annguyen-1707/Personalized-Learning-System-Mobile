import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personalized_learning_system_mobile/core/theme/app_theme.dart';
import 'package:personalized_learning_system_mobile/features/auth/screens/login_screen.dart';
import 'package:personalized_learning_system_mobile/features/courses/screens/courses_screen.dart';
import 'package:personalized_learning_system_mobile/features/practice/screens/practice_screen.dart';
import 'package:personalized_learning_system_mobile/features/profile/screens/dashboard_screen.dart';
import 'package:personalized_learning_system_mobile/features/profile/screens/profile_screen.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(FuOhayoApp(state: AppState()));
}

class FuOhayoApp extends StatelessWidget {
  const FuOhayoApp({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AppStateScope(
          state: state,
          child: ShadApp.custom(
            theme: AppTheme.shadTheme(),
            appBuilder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'FU OHAYO',
                theme: AppTheme.materialTheme(),
                home: const AuthGate(),
              );
            },
          ),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.watch(context);
    if (!state.auth.isAuthenticated) {
      return const LoginScreen();
    }
    state.loadInitialData();
    return const HomeShell();
  }
}

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _screens = <Widget>[
    DashboardScreen(),
    CoursesScreen(),
    PracticeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.watch(context);
    final titles = ['Trang chủ', 'Khóa học', 'Luyện tập', 'Hồ sơ'];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.h,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titles[state.tabIndex]),
            Text(
              'FU OHAYO personalized learning',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          ShadButton.ghost(
            width: 54.w,
            height: 54.w,
            onPressed: () {},
            child: const Icon(Icons.notifications_none_rounded),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: IndexedStack(index: state.tabIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.tabIndex,
        onDestinationSelected: state.changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Course',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none_rounded),
            selectedIcon: Icon(Icons.mic_rounded),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
