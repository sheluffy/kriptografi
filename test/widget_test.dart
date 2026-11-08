import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Sesuaikan path import ini dengan nama package aplikasi Anda (misal: 'nama_project/main.dart')
// Jika belum tahu nama package-nya, Anda bisa melihat baris pertama di pubspec.yaml (name: ...)
import 'package:kriptografi/main.dart'; 

void main() {
  testWidgets('Uji navigasi Tab Enkripsi dan Dekripsi NFV-256', (WidgetTester tester) async {
    // 1. Jalankan aplikasi
    await tester.pumpWidget(const NfvApp());

    // 2. Verifikasi bahwa judul aplikasi dan tab awal (Enkripsi) tampil
    expect(find.text('NFV-256 Cipher'), findsOneWidget);
    expect(find.text('Plaintext'), findsOneWidget);
    expect(find.text('Kunci'), findsOneWidget);

    // 3. Cari tombol "Isi contoh" di tab Enkripsi lalu ketuk
    final isiContohButton = find.text('Isi contoh');
    expect(isiContohButton, findsOneWidget);
    await tester.tap(isiContohButton);
    await tester.pump();

    // 4. Verifikasi tombol "Enkripsi" berfungsi dan memunculkan hasil (Ciphertext)
    final enkripsiButton = find.widgetWithText(FilledButton, 'Enkripsi');
    expect(enkripsiButton, findsOneWidget);
    await tester.tap(enkripsiButton);
    await tester.pump();

    // Pastikan kotak hasil ciphertext muncul
    expect(find.text('Ciphertext'), findsOneWidget);

    // 5. Berpindah ke Tab Dekripsi
    await tester.tap(find.text('Dekripsi'));
    await tester.pumpAndSettle(); // Tunggu animasi transisi tab selesai

    // Verifikasi elemen di tab Dekripsi tampil
    expect(find.text('Kirim ke Dekripsi'), findsNothing); // Sudah di tab dekripsi
    // Di tab dekripsi, field input utamanya bernama 'Ciphertext'
    expect(find.widgetWithText(TextField, 'Ciphertext'), findsOneWidget);
  });
}