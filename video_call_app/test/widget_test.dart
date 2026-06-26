import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:video_call_app/core/di/service_locator.dart';
import 'package:video_call_app/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    ServiceLocator.instance.init();
  });

  testWidgets('App renders join screen', (WidgetTester tester) async {
    await tester.pumpWidget(const VideoCallApp());
    expect(find.text('Join Call'), findsOneWidget);
  });
}
