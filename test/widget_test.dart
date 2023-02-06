// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/forms/add_task_form.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/util/app_state.dart';

class MockAppState extends Mock implements AppState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('The widget that lists all the tasks', (() {
    // Empty task test
    test('no tasks listed', () async {
      expect(AppState.getAllTasks(), []);
    });

    // Test for button navigating to createNewTask page
    testWidgets('Button is present and triggers navigation after tapped',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      final addTaskButton = find.byKey(const ValueKey("addTaskButton"));
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      expect(addTaskButton, findsOneWidget);
      await tester.tap(addTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddTask), findsOneWidget);
    });
  }));

  // Each task fields test
  group('Each task listed in the widget that lists all the tasks', (() {}));

  group('The widget for creating a new task', (() {}));

  group('The widget for editing an existing task', (() {}));
}
