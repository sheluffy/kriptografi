class NfvStep {
  final int index; // 1-based
  final bool isSpace;
  final int input; // P (enkripsi) atau C (dekripsi)
  final int output; // C (enkripsi) atau P (dekripsi)
  final String char; // huruf plaintext
  final String keyChar;
  final int keyValue;
  final int feedback;

  const NfvStep({
    required this.index,
    this.isSpace = false,
    this.input = 0,
    this.output = 0,
    this.char = '',
    this.keyChar = '',
    this.keyValue = 0,
    this.feedback = 0,
  });
}