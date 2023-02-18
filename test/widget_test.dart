import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/forms/add_task_form.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/task_details.dart';
import 'package:myapp/util/database_helper.dart';
import 'package:myapp/util/show_task_list.dart';

class MockAppState extends Mock implements DatabaseHelper {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Group 1 => The widget that lists all the tasks
  group('The widget that lists all the tasks => ', (() {
    // Empty task test
    testWidgets('no tasks listed', (WidgetTester tester) async {
      //find all widgets needed
      final List<Task> tasks = DatabaseHelper.getAllTasks();

      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: HomePage(),
      ));

      find.byType(TaskList);

      final expectedListFinder = find.byKey(const ValueKey("taskList"));

      // Verify that there is a listView.builder and an empty list in it.
      expect(expectedListFinder, findsOneWidget);
      expect(tasks, []);
    });

    // Test for button navigating to createNewTask widget
    testWidgets(
        'button is present and triggers navigator to go to the create new task widget',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      final addTaskButton = find.byKey(const ValueKey("addTaskButton"));

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      // Verify that addTaskButton exists and tap on it
      expect(addTaskButton, findsOneWidget);
      await tester.tap(addTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in AddTask widget and there is a createTaskButton.
      expect(find.byType(AddTask), findsOneWidget);
      expect(find.byKey(const ValueKey('createTaskButton')), findsOneWidget);
    });

    // Test for each task is in a separate widget
    testWidgets(
        'shows a separate widget for each task when there are tasks to list',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 1 rrrrrrtsdfqfdsq';
      const taskDesc = 'ashfbkajbfsjhafbksdfbsjhdfbdsjf';
      final goToTask = find.byKey(const ValueKey("goToTask"));
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage and there is a taskTitle we just created.
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);

      await tester.tap(goToTask);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails widget.
      expect(find.byType(TaskDetails), findsOneWidget);
    });

    // Test for filtered tasks
    testWidgets('shows only some of the tasks when a filter is applied',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'ajshfbakjfska';
      const taskDesc = 'ashfbkajbfsjhafbksdfbsjhdfbdsjf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final dropDownFilterBy = find.byKey(const ValueKey('dropDownFilterBy'));
      final dropdownItem = find.text('Open').last;
      final dropdownItem2 = find.text('Completed').last;

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify we are in HomePage and there is a taskTitle.
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);

      // Tap the dropdown and choose 'Open'
      await tester.tap(dropDownFilterBy);
      await tester.pumpAndSettle();
      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      // Verify that there is a task with status 'Open'
      expect(find.text(taskTitle), findsOneWidget);

      // Tap the dropdown and choose 'Completed'
      await tester.tap(dropDownFilterBy);
      await tester.pumpAndSettle();
      await tester.tap(dropdownItem2);
      await tester.pumpAndSettle();

      // Verify that there is no task with status 'Completed'
      expect(find.text(taskTitle), findsNothing);
    });
  }));

  // Group 2 => Each task listed in the widget that lists all the tasks
  group('Each task listed in the widget that lists all the tasks => ', (() {
    // Indicates the name of the task.
    testWidgets('indicates the name of the task', (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 2 esdfg';
      const taskDesc = 'urhgiuhgf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage indicates the name fo the task
      expect(find.byType(HomePage), findsOneWidget);
      final expectedTextFinder = find.text(taskTitle);
      expect(expectedTextFinder, findsOneWidget);
    });

    // Go to the edit existing task widget
    testWidgets(
        'button is present and triggers navigator to go to the edit existing task widget',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 3 www';
      const taskDesc = 'sjhfbakfabka';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask')).first;

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Tap to the goToTaskButton
      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails widget
      expect(find.byType(TaskDetails), findsOneWidget);
    });
  }));

  // Group 3 => The widget for creating a new task
  group('The widget for creating a new task => ', (() {
    testWidgets(
        'produces a task whose title and description match the ones entered by the user',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'random title 4 qqqqqqweqwe';
      const taskDesc = 'ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask')).first;

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Tap to the goToTaskButton
      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails widget. Also, title and description match the ones entered by the user.
      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);
    });
  }));

  // Group 4 =>
  group('The widget for editing an existing task => ', (() {
    testWidgets('Fills out the title and description of the existing task',
        (WidgetTester tester) async {
      //find all widgets needed
      const taskTitle = 'random title qqqqqqweqwe';
      const taskDesc = 'ajshfbksjdfnhjdsbf';
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

      expect(find.byKey(const ValueKey('taskUpdateButton')), findsOneWidget);

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitleEdit')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDescriptionEdit')), taskDesc);
      await tester.pumpAndSettle();

      // Verify that we are filled out the title and description
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);
    });

    testWidgets('updates the existing task instead of creating a new task',
        (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'blabkabka qqqqqqweqwe';
      const taskDesc = 'ajshfbksjdfnhjdsbf';
      const taskTitleEdit = 'edit blabkabka qqqqqqweqwe';
      const taskDescEdit = 'edit ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask')).first;
      final taskUpdateButton = find.byKey(const ValueKey('taskUpdateButton'));

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Tap to the goToTaskButton
      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails and there is title and description
      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitleEdit')), taskTitleEdit);
      await tester.enterText(
          find.byKey(const ValueKey('taskDescriptionEdit')), taskDescEdit);
      await tester.tap(taskUpdateButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage and the task is updated
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(taskTitleEdit), findsOneWidget);
    });
  }));

  group('Bonus tests => ', (() {
    //Adds a task
    testWidgets('user can add task', (tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'Task to add';
      const taskDesc = 'description ajshfbksjdfnhjdsbf';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that the task is added
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
    });

    // Delete the task
    testWidgets('user can delete task', (tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const taskTitle = 'Task to delete';
      const taskDesc = 'description akshbakfa';
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final goToTaskButton = find.byKey(const ValueKey('goToTask')).first;
      final deleteTaskButton =
          find.byKey(const ValueKey('deleteTaskButton')).first;

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), taskTitle);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), taskDesc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in Homepge and tap to the goToTaskButton
      expect(find.byType(HomePage), findsOneWidget);
      await tester.tap(goToTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails and there is a title and description
      expect(find.byType(TaskDetails), findsOneWidget);
      expect(find.text(taskTitle), findsOneWidget);
      expect(find.text(taskDesc), findsOneWidget);

      // Tap to the deleteTaskButton and confirm cupertinoDialogAction
      await tester.tap(deleteTaskButton);
      await tester.pump();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify that taskTitle no more exists
      expect(find.text(taskTitle), findsNothing);
    });

    // Link between tasks
    testWidgets('user can add link between tasks', (WidgetTester tester) async {
      //find all widgets needed
      final mockObserver = MockNavigatorObserver();
      const task1Title = 'random title 1 rrrrrrtsdfqfdsq';
      const task1Desc = 'ashfbkajbfsjhafbksdfbsjhdfbdsjf';
      const task2Title = 'random title znxc znbc nz';
      const task2Desc = 'jahsadbj ashkgadbks';
      final addTaskButton = find.byKey(const ValueKey('addTaskButton'));
      final goToTask = find.byKey(const ValueKey("goToTask")).first;
      final createTaskButton = find.byKey(const ValueKey('createTaskButton'));
      final addRelatioButton = find.byKey(const ValueKey('addRelationButton'));
      final dropdownLink = find.byKey(const ValueKey('dropDownLink'));

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddTask(),
        navigatorObservers: [mockObserver],
      ));

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), task1Title);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), task1Desc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Tap to the addTaskButton
      await tester.tap(addTaskButton);
      await tester.pumpAndSettle();

      // Fill the forms and tap to the createTaskButton
      await tester.enterText(
          find.byKey(const ValueKey('taskTitle')), task2Title);
      await tester.enterText(
          find.byKey(const ValueKey('taskDecription')), task2Desc);
      await tester.tap(createTaskButton);
      await tester.pumpAndSettle();

      // Verify that we are in HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Tap to the goToTask
      await tester.tap(goToTask);
      await tester.pumpAndSettle();

      // Verify that we are in TaskDetails
      expect(find.byType(TaskDetails), findsOneWidget);

      // Tap to the dropDown and select task1Title
      await tester.tap(dropdownLink);
      await tester.pumpAndSettle();

      final dropdownItem = find.text(task1Title).last;
      await tester.tap(dropdownItem);
      await tester.pumpAndSettle();

      // Tap to the addRelationButton
      await tester.tap(addRelatioButton);
      await tester.pumpAndSettle();

      // Tap to the related Task
      await tester.tap(find.byKey(const ValueKey('goToRelatedTask')));
      await tester.pumpAndSettle();

      // Verify that we are in the right place
      expect(find.text(task2Title), findsOneWidget);
    });
  }));
}
