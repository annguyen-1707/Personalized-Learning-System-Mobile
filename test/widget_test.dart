import 'package:flutter_test/flutter_test.dart';
import 'package:personalized_learning_system_mobile/main.dart';
import 'package:personalized_learning_system_mobile/shared/providers/app_state_provider.dart';

void main() {
  testWidgets('shows login screen', (tester) async {
    await tester.pumpWidget(FuOhayoApp(state: AppState()));
    await tester.pumpAndSettle();

    expect(find.text('FU OHAYO'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
  });
}
