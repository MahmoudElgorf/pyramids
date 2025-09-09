import 'package:flutter/material.dart';

class ThemePickerSheet extends StatefulWidget {
  const ThemePickerSheet({
    super.key,
    required this.current,
    required this.onPick,
  });

  final ThemeMode current;
  final ValueChanged<ThemeMode> onPick;

  @override
  State<ThemePickerSheet> createState() => _ThemePickerSheetState();
}

class _ThemePickerSheetState extends State<ThemePickerSheet> {
  late ThemeMode _temp;

  @override
  void initState() {
    super.initState();
    _temp = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;

    // يتطلب Dart 3 لاستخدام records. لو عايز تدعم نسخ أقدم، استبدله بكلاس صغير.
    final List<({String label, ThemeMode mode, IconData icon})> opts = [
      (label: 'Follow System', mode: ThemeMode.system, icon: Icons.settings_suggest),
      (label: 'Light', mode: ThemeMode.light, icon: Icons.light_mode),
      (label: 'Dark', mode: ThemeMode.dark, icon: Icons.dark_mode),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16, right: 16, top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ...opts.map((o) => RadioListTile<ThemeMode>(
              value: o.mode,
              groupValue: _temp,
              title: Row(
                children: [
                  Icon(o.icon, color: c.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Text(o.label),
                ],
              ),
              onChanged: (m) {
                if (m == null) return;
                setState(() => _temp = m);
              },
            )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onPick(_temp),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
