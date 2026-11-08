import 'package:flutter/material.dart';

class TabBody extends StatelessWidget {
  final Widget header;
  final List<Widget> children;

  const TabBody({super.key, required this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [header, const SizedBox(height: 16), ...children],
        ),
      ),
    );
  }
}