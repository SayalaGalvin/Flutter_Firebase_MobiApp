import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_project/loginpage.dart';
import 'package:flutter_project/services/signInPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Login navigation Tests', ()
  {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<Null> _buildMainPage (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
        navigatorObservers: [mockObserver],
      ));

      verify(mockObserver.didPush(any, any));
    }

    Future<Null> _navigateToDetailsPage (WidgetTester tester) async {
      await tester.tap(find.byKey(LoginPage.navigateToDetailsButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('When tapping "Create an Account" button, should navigate to Signin Page',
            (WidgetTester tester) async {
          await _buildMainPage(tester);
          await _navigateToDetailsPage(tester);

          verify(mockObserver.didPush(any, any));

          expect(find.byType(signInPage), findsOneWidget);
        });
    testWidgets('Tapping "Cancel" button, should navigate to Login Page',
            (WidgetTester tester) async {

          await _buildMainPage(tester);
          await _navigateToDetailsPage(tester);


          final Route pushedRoute =
              verify(mockObserver.didPush(captureAny, any))
                  .captured
                  .single;

          String popResult;
          pushedRoute.popped.then((result) => popResult = result);

          await tester.tap(find.byKey(signInPage.popWithResultButtonKey));
          await tester.pumpAndSettle();

        });
  });
}