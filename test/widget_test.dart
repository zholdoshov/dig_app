import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/forms/add_task_form.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/task_details.dart';
import 'package:myapp/util/app_state.dart';
import 'package:myapp/util/show_task_list.dart';

class MockAppState extends Mock implements AppState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Group 1 => The widget that lists all the tasks
  group('The widget that lists all the tasks', (() {
    // Empty task test
    testWidgets('no tasks listed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomePage(),
      ));

      find.byType(TaskList);

      final expectedListFinder = find.byKey(const ValueKey("taskList"));

      expect(expectedListFinder, findsOneWidget);
      expect(AppState.getAllTasks(), []);
    });

    // Test for button navigating to createNewTask page
    testWidgets(
        'button is present and triggers navigator to go to the create new task widget',
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
      expect(find.byKey(const ValueKey('createTaskButton')), findsOneWidget);
    });

    // Test for separate widget for each task
    testWidgets(
        'shows a separate widget for each task when there are tasks to list',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 1 rrrrrrtsdfqfdsq';
      const taskDesc = 'ashfbkajbfsjhafbksdfbsjhdfbdsjf';
      final goToTask = find.byKey(const ValueKey("goToTask"));
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(goToTask, findsOneWidget);

      await tester.tap(goToTask);
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetails), findsOneWidget);
    });
  }));

  // Group 2 => Each task listed in the widget that lists all the tasks
  group('Each task listed in the widget that lists all the tasks', (() {
    // Indicates the name of the task.
    testWidgets('indicates the name of the task', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 2 eeeeqrqree';
      const taskDesc = 'akshfvjahsfvhgsvfkajbfkajba';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);

      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      final expectedTextFinder = find.text(taskTitle);
      expect(expectedTextFinder, findsOneWidget);
    });

    testWidgets(
        'button is present and triggers navigator to go to the edit existing task widget',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 3 wwwweasaqdq';
      const taskDesc = 'sjhfbakfabka';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);

      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();
      // expect(find.byType(HomePage), findsOneWidget);

      expect(find.byType(TaskList), findsOneWidget);
      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();
      expect(find.byType(TaskDetails), findsOneWidget);
    });
  }));

  // Group 3 =>
  group('The widget for creating a new task', (() {
    testWidgets(
        'produces a task whose title and description match the ones entered by the user',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 4 qqqqqqweqwe';
      const taskDesc = 'ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);

      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);
    });
  }));

  // Group 4 =>
  group('The widget for editing an existing task', (() {
    testWidgets('Fills out the title and description of the existing task',
        (WidgetTester tester) async {
      Task task = Task(
          id: 1,
          title: 'Title',
          description: 'description',
          status: TaskStatus.Open,
          updateTime: DateTime.now());
      await tester.pumpWidget(MaterialApp(
        home: TaskDetails(
          task: task,
        ),
      ));
    });
  }));

  group('Bonus tests', (() {
    //User adds a task
    testWidgets('user can add task', (tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'Task to add';
      const taskDesc = 'description ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);

      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);
    });

    // User delete the task
    testWidgets('user can delete task', (tester) async {
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'Task to add';
      const taskDesc = 'description ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask'));
      final deleteTaskButton = find.byKey(const ValueKey('deleteTaskButton'));

      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);

      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);

      await tester.tap(deleteTaskButton);
      await tester.pumpAndSettle();
      // expect(find.text(taskTitle), findsNothing);
    });
  }));
}
