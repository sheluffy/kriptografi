import '../models/nfv_result.dart';
import '../models/nfv_step.dart';

/// Logika inti NFV-256 (Neighbor-Feedback Vigenère 256).
class Nfv256Service {
  static const int modulus = 256;
  static const String spaceToken = '/';

  static int _mod(int n, int m) => ((n % m) + m) % m;

  static void validateKey(String key) {
    if (key.isEmpty) {
      throw const FormatException('Kunci tidak boleh kosong.');
    }
    for (final u in key.codeUnits) {
      if (u > 255) {
        throw const FormatException(
            'Kunci hanya boleh berisi karakter ASCII 0–255.');
      }
    }
  }

  static NfvResult encrypt(String plaintext, String key) {
    if (plaintext.isEmpty) {
      throw const FormatException('Plaintext tidak boleh kosong.');
    }
    validateKey(key);

    final units = plaintext.codeUnits;
    final keyUnits = key.codeUnits;
    final out = <String>[];
    final steps = <NfvStep>[];
    var fb = 0;

    for (var i = 0; i < units.length; i++) {
      final p = units[i];
      if (p > 255) {
        throw FormatException(
            'Karakter "${String.fromCharCode(p)}" di luar ASCII 0–255.');
      }
      if (p == 32) {
        out.add(spaceToken);
        steps.add(NfvStep(index: i + 1, isSpace: true));
        continue;
      }
      final k = keyUnits[i % keyUnits.length];
      final c = (p + k + fb) % modulus;

      steps.add(NfvStep(
        index: i + 1,
        input: p,
        output: c,
        char: String.fromCharCode(p),
        keyChar: String.fromCharCode(k),
        keyValue: k,
        feedback: fb,
      ));
      out.add('$c');
      fb = c % 10;
    }
    return NfvResult(out.join(' '), steps);
  }

  static NfvResult decrypt(String ciphertext, String key) {
    validateKey(key);
    final tokens = ciphertext
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    if (tokens.isEmpty) {
      throw const FormatException('Ciphertext tidak boleh kosong.');
    }

    final keyUnits = key.codeUnits;
    final buf = StringBuffer();
    final steps = <NfvStep>[];
    var fb = 0;

    for (var i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      if (t == spaceToken) {
        buf.write(' ');
        steps.add(NfvStep(index: i + 1, isSpace: true));
        continue;
      }
      if (!RegExp(r'^\d+$').hasMatch(t) || int.parse(t) > 255) {
        throw FormatException(
            'Token tidak valid. Gunakan angka 0–255 atau tanda /.');
      }
      final c = int.parse(t);
      final k = keyUnits[i % keyUnits.length];
      final p = _mod(c - k - fb, modulus);
      final ch = String.fromCharCode(p);

      steps.add(NfvStep(
        index: i + 1,
        input: c,
        output: p,
        char: ch,
        keyChar: String.fromCharCode(k),
        keyValue: k,
        feedback: fb,
      ));
      buf.write(ch);
      fb = c % 10;
    }
    return NfvResult(buf.toString(), steps);
  }
}