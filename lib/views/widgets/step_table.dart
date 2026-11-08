import 'package:flutter/material.dart';
import '../../models/nfv_step.dart';

class StepTable extends StatelessWidget {
  final List<NfvStep> steps;
  final bool encrypt;

  const StepTable({super.key, required this.steps, required this.encrypt});

  static String _show(String ch) {
    if (ch.isEmpty) return '';
    final u = ch.codeUnitAt(0);
    if (u < 32 || (u >= 127 && u < 160)) {
      return '\\x${u.toRadixString(16).padLeft(2, '0')}';
    }
    return ch;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cols = encrypt
        ? ['i', 'Huruf', 'P', 'Kunci', 'K', 'Feedback', 'C']
        : ['i', 'C', 'Kunci', 'K', 'Feedback', 'P', 'Huruf'];
    final fbIdx = encrypt ? 5 : 4;
    const resIdx = 6;

    List<String> cells(NfvStep s) {
      if (s.isSpace) {
        return encrypt
            ? ['${s.index}', '(spasi)', '—', '—', '—', '—', '/']
            : ['${s.index}', '/', '—', '—', '—', '—', '(spasi)'];
      }
      return encrypt
          ? [
              '${s.index}',
              _show(s.char),
              '${s.input}',
              _show(s.keyChar),
              '${s.keyValue}',
              '${s.feedback}',
              '${s.output}'
            ]
          : [
              '${s.index}',
              '${s.input}',
              _show(s.keyChar),
              '${s.keyValue}',
              '${s.feedback}',
              '${s.output}',
              _show(s.char)
            ];
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 24,
            headingRowHeight: 44,
            dataRowMinHeight: 38,
            dataRowMaxHeight: 42,
            headingRowColor: WidgetStateProperty.all(cs.surfaceContainerHighest.withOpacity(0.6)),
            columns: [
              for (final c in cols)
                DataColumn(
                  label: Text(
                    c,
                    style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary),
                  ),
                ),
            ],
            rows: [
              for (int i = 0; i < steps.length; i++)
                DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>(
                    (states) => i.isEven ? cs.surfaceContainerLowest.withOpacity(0.3) : null,
                  ),
                  cells: [
                    for (var j = 0; j < cols.length; j++)
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            color: (!steps[i].isSpace && j == fbIdx)
                                ? cs.tertiaryContainer.withOpacity(0.4)
                                : null,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cells(steps[i])[j],
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              fontStyle: steps[i].isSpace ? FontStyle.italic : FontStyle.normal,
                              fontWeight: (!steps[i].isSpace && j == resIdx)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: (!steps[i].isSpace && j == resIdx)
                                  ? cs.primary
                                  : cs.onSurface,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}