import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dp2/screens/sign_up_screen.dart'; // Adjust the import path

void main() {
  group('Sign Up Screen Tests', () {
    testWidgets('Sign Up Screen displays correctly', (WidgetTester tester) async {
      // Build the SignUpScreen widget
      await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

      // Check for email, password, and confirm password fields
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Check for the Sign Up button
      expect(find.byKey(Key('signUpButton')), findsOneWidget);
    });

    testWidgets('Sign Up button triggers error if fields are empty', (WidgetTester tester) async {
      // Build the SignUpScreen widget
      await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

      // Tap the Sign Up button
      await tester.tap(find.byKey(Key('signUpButton')));
      await tester.pump();

      // Verify that the first validation error is displayed
      expect(find.text('Email is required.'), findsOneWidget);
    });

    testWidgets('Sign Up button triggers password mismatch error', (WidgetTester tester) async {
      // Build the SignUpScreen widget
      await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

      // Enter email
      await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');

      // Enter mismatched passwords
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password456');

      // Tap the Sign Up button
      await tester.tap(find.byKey(Key('signUpButton')));
      await tester.pump();

      // Verify that the password mismatch error is displayed
      expect(find.text('Passwords do not match.'), findsOneWidget);
    });
  });
}
