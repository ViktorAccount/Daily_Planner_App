import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dp2/screens/login_screen.dart'; // Adjust the import path to your project structure

void main() {
  group('Login Screen Tests', () {
    testWidgets('Login Screen displays correctly', (WidgetTester tester) async {
      // Build the LoginScreen widget
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Check for email and password fields
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check for the Login button
      expect(find.byKey(Key('loginButton')), findsOneWidget);

      // Check for Create an Account button
      expect(find.text('Create an Account'), findsOneWidget);
    });

    testWidgets('Login button triggers error if fields are empty', (WidgetTester tester) async {
      // Build the LoginScreen widget
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Tap the login button using the Key
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pump();

      // Verify that an error dialog is displayed
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('Validates email and password fields', (WidgetTester tester) async {
      // Build the LoginScreen widget
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Enter email but leave the password empty
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pump();

      // Verify the error dialog is displayed
      expect(find.text('Please fill in all fields'), findsOneWidget);

      // Enter both email and password and try again
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pump();

      // Since Firebase isn't connected during testing, there's no error expected now.
      // In real tests, this would navigate or show success feedback.
    });
  });
}
