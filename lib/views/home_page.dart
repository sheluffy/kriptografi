import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/nfv_result.dart';
import '../services/nfv256_service.dart';
import 'widgets/result_box.dart';
import 'widgets/step_table.dart';
import 'widgets/tab_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final _ePt = TextEditingController();
  final _eKey = TextEditingController();
  final _dCt = TextEditingController();
  final _dKey = TextEditingController();
  
  NfvResult? _encRes, _decRes;
  String? _encErr, _decErr;

  @override
  void dispose() {
    _tabs.dispose();
    _ePt.dispose();
    _eKey.dispose();
    _dCt.dispose();
    _dKey.dispose();
    super.dispose();
  }

  void _encrypt() {
    setState(() {
      _encErr = null;
      _encRes = null;
      try {
        _encRes = Nfv256Service.encrypt(_ePt.text, _eKey.text);
      } on FormatException catch (e) {
        _encErr = e.message;
      }
    });
  }

  void _decrypt() {
    setState(() {
      _decErr = null;
      _decRes = null;
      try {
        _decRes = Nfv256Service.decrypt(_dCt.text, _dKey.text);
      } on FormatException catch (e) {
        _decErr = e.message;
      }
    });
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: const Text('Berhasil disalin ke clipboard!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 15)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('NFV-256 Cipher Studio', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cs.surface,
        surfaceTintColor: cs.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: cs.surface,
            child: TabBar(
              controller: _tabs,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'Enkripsi (Encryption)'), 
                Tab(text: 'Dekripsi (Decryption)')
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabs,
          children: [_encryptTab(), _decryptTab()],
        ),
      ),
    );
  }

  Widget _encryptTab() {
    final res = _encRes;
    return TabBody(
      header: const SizedBox.shrink(),
      children: [
        _buildSectionCard(
          title: 'Parameter Input',
          children: [
            TextField(
              controller: _ePt,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Plaintext',
                hintText: 'Masukkan teks rahasia...',
                prefixIcon: Icon(Icons.text_fields),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eKey,
              decoration: const InputDecoration(
                labelText: 'Kunci Enkripsi (Key)',
                hintText: 'Contoh: KUNCIK',
                prefixIcon: Icon(Icons.key_rounded),
                helperText: 'Karakter ASCII 0–255. Kunci diulang sesuai posisi.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _encrypt,
                    icon: const Icon(Icons.lock_rounded),
                    label: const Text('Proses Enkripsi'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _ePt.text = 'KETEMU DI KAMPUS';
                    _eKey.text = 'KUNCIK';
                  },
                  icon: const Icon(Icons.auto_fix_high_rounded),
                  label: const Text('Contoh'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_encErr != null) _ErrorCard(_encErr!),
        if (res != null) ...[
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'Hasil Ciphertext',
            children: [
              ResultBox(text:res.text),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                ActionChip(
                  avatar: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Salin Hasil'),
                  onPressed: () => _copy(res.text),
                ),
                ActionChip(
                  avatar: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('Kirim ke Dekripsi'),
                  onPressed: () {
                    _dCt.text = res.text;
                    _dKey.text = _eKey.text;
                    _tabs.animateTo(1);
                  },
                ),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Rincian Langkah Iterasi'),
          const SizedBox(height: 8),
          StepTable(steps: res.steps, encrypt: true),
        ],
      ],
    );
  }

  Widget _decryptTab() {
    final res = _decRes;
    return TabBody(
      header: const SizedBox.shrink(),
      children: [
        _buildSectionCard(
          title: 'Parameter Input',
          children: [
            TextField(
              controller: _dCt,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ciphertext (Desimal)',
                hintText: 'Contoh: 150 154 166 142...',
                prefixIcon: Icon(Icons.numbers_rounded),
                helperText: 'Pisahkan dengan spasi. Gunakan / untuk spasi asli.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dKey,
              decoration: const InputDecoration(
                labelText: 'Kunci Dekripsi (Key)',
                hintText: 'Contoh: KUNCIK',
                prefixIcon: Icon(Icons.key_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _decrypt,
                    icon: const Icon(Icons.lock_open_rounded),
                    label: const Text('Proses Dekripsi'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _dCt.text = '150 154 166 142 152 162';
                    _dKey.text = 'KUNCIK';
                  },
                  icon: const Icon(Icons.auto_fix_high_rounded),
                  label: const Text('Contoh'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_decErr != null) _ErrorCard(_decErr!),
        if (res != null) ...[
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'Hasil Plaintext Pemulihan',
            children: [
              ResultBox(text: res.text),
              const SizedBox(height: 12),
              ActionChip(
                avatar: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Salin Plaintext'),
                onPressed: () => _copy(res.text),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Rincian Langkah Iterasi'),
          const SizedBox(height: 8),
          StepTable(steps: res.steps, encrypt: false),
        ],
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.primary)),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      );
}

class _ErrorCard extends StatelessWidget {
  final String text;
  const _ErrorCard(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: cs.onErrorContainer, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}