import 'package:flutter/material.dart';

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading) ...[
          SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          // الأيقونة هتورّث اللون من foregroundColor بتاع الزرار
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );

    return Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      child: SizedBox(
        width: fullWidth ? double.infinity : null,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            disabledBackgroundColor: scheme.primary.withOpacity(.4),
            disabledForegroundColor: scheme.onPrimary.withOpacity(.6),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: (onPressed != null && !loading) ? onPressed : null,
          child: content,
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Chip(
      backgroundColor: isDark
          ? scheme.surface.withOpacity(.14)
          : scheme.surfaceVariant.withOpacity(.22),
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      avatar: Icon(icon, size: 16, color: scheme.onSurfaceVariant),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class OutlinedPill extends StatelessWidget {
  const OutlinedPill({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
        color: isDark
            ? scheme.surface.withOpacity(.13)
            : scheme.surfaceVariant.withOpacity(.18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // مفيش لزوم نفرض لون ذهبي هنا لو انت حاطط titleLarge ذهبي في الثيم
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: theme.iconTheme.copyWith(color: theme.colorScheme.onSurfaceVariant),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}
