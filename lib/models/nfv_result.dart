import 'nfv_step.dart';

class NfvResult {
  final String text;
  final List<NfvStep> steps;

  const NfvResult(this.text, this.steps);
}