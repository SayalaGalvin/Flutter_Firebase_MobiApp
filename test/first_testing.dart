import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('validate appbar widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Rotaract Club Badulla'),
          ),
        )
    ));
    expect(find.text('Rotaract Club Badulla'), findsOneWidget);
  });

  
}