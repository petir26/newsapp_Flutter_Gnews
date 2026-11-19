import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/widgets/search_dialog.dart';

void main() {
  testWidgets('mengembalikan kata kunci dan menutup dialog tanpa controller terpakai ulang', (tester) async {
    String? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              result = await showDialog<String>(
                context: context,
                builder: (_) => const SearchDialog(),
              );
            },
            child: const Text('Buka'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), ' berita ');
    await tester.tap(find.text('Cari'));
    await tester.pumpAndSettle();

    expect(result, 'berita');
    expect(tester.takeException(), isNull);
  });
}
