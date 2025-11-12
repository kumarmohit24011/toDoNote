
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:to_do_note/main.dart';
import 'package:to_do_note/providers/task_provider.dart';
import 'package:to_do_note/providers/theme_provider.dart';

void main() {
  testWidgets('HomeScreen has a title and tabs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => TaskProvider()),
        ],
        child: const ToDoApp(),
      ),
    );

    // Verify that our app has the correct title.
    expect(find.text('ToDoNote'), findsOneWidget);

    // Verify that our app has the correct tabs.
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });
}
