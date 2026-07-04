import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reencontro/main.dart';

void main() {
  testWidgets('renders splash content', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
