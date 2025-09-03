import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class GoldButton extends StatelessWidget {
  const GoldButton({super.key, required this.label, required this.onPressed});
  final String label; final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.label});
  final IconData icon; final String label;
  @override
  Widget build(BuildContext context) {
    return Chip(
      side: const BorderSide(color: Color(0x33FFD700)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      avatar: Icon(icon, size: 16),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class OutlinedPill extends StatelessWidget {
  const OutlinedPill({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33FFD700)),
        color: const Color(0x221F1F1F),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleLarge,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}
