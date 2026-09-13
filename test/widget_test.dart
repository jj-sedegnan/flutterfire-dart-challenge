import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_dart_challenge/main.dart';

void main() {
  group('Flutter GUI Widget Tests', () {
    testWidgets('Renders app bar, products and category chips', (WidgetTester tester) async {
      await tester.pumpWidget(const NextFlutterApp());
      await tester.pumpAndSettle();

      // Verify app title
      expect(find.text('NextFlutter Boutique'), findsOneWidget);
      expect(find.text('Pattern Repository<T> & OOP'), findsOneWidget);

      // Verify initial seeded products are displayed
      expect(find.text('MacBook Pro M3 Max'), findsOneWidget);
      expect(find.text('Clavier Mécanique Sans Fil'), findsOneWidget);

      // Verify category chips
      expect(find.text('Tous'), findsOneWidget);
      expect(find.text('Informatique'), findsWidgets);
      expect(find.text('Périphériques'), findsWidgets);
    });

    testWidgets('Opens Drawer and displays navigation menu items', (WidgetTester tester) async {
      await tester.pumpWidget(const NextFlutterApp());
      await tester.pumpAndSettle();

      // Tap hamburger menu icon to open drawer
      final drawerButton = find.byTooltip('Open navigation menu');
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
      } else {
        final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
        scaffoldState.openDrawer();
      }
      await tester.pumpAndSettle();

      // Verify drawer contents
      expect(find.text('NextFlutter App'), findsOneWidget);
      expect(find.text('Catalogue Produits'), findsOneWidget);
      expect(find.text('Bac à sable Exceptions'), findsOneWidget);
      expect(find.text('Statistiques & Stock'), findsOneWidget);
      expect(find.text('Architecture & Tests'), findsOneWidget);

      // Navigate to Exceptions Sandbox
      await tester.tap(find.text('Bac à sable Exceptions'));
      await tester.pumpAndSettle();

      // Verify Sandbox is rendered
      expect(find.text('Bac à sable des Exceptions Métier'), findsOneWidget);
      expect(find.text('DuplicateEntityException'), findsOneWidget);
      expect(find.text('EntityNotFoundException'), findsOneWidget);
      expect(find.text('ValidationException'), findsOneWidget);
    });
  });
}
