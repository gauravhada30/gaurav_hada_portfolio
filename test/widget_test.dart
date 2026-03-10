import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaurav_hada_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
