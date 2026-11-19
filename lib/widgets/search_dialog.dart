import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
        contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 4),
        actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cari berita', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
            SizedBox(height: 5),
            Text(
              'Masukkan topik atau kata kunci berita.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          maxLength: 100,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Contoh: teknologi',
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            counterStyle: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.search_rounded, size: 18),
            label: const Text('Cari'),
          ),
        ],
      );
}
