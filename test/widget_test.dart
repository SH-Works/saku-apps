import 'package:flutter_test/flutter_test.dart';

import 'package:saku_apps/core/utils/currency_formatter.dart';

void main() {
  group('formatRupiah', () {
    test('formats positive amounts with dot thousand separator', () {
      expect(formatRupiah(0), 'Rp 0');
      expect(formatRupiah(1000), 'Rp 1.000');
      expect(formatRupiah(1250000), 'Rp 1.250.000');
      expect(formatRupiah(3251606), 'Rp 3.251.606');
    });

    test('formats negative amounts with leading minus', () {
      expect(formatRupiah(-1500), '-Rp 1.500');
    });
  });

  group('parseRupiah', () {
    test('parses formatted strings back to int', () {
      expect(parseRupiah('Rp 1.250.000'), 1250000);
      expect(parseRupiah(''), 0);
      expect(parseRupiah('Rp 0'), 0);
    });
  });
}
