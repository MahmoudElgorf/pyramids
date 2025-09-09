import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = t.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: t.textTheme.titleSmall?.copyWith(
              color: c.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 1,
                      color: c.outlineVariant.withOpacity(.45),
                    ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Basic setting row with title + subtitle and chevron
class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      trailing: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
      title: Row(
        children: [
          Icon(Icons.verified, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodyLarge,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsetsDirectional.only(start: 36),
        child: Text(
          subtitle,
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () {
        Feedback.forTap(context);
        onTap?.call();
      },
    );
  }
}

/// Info row with value and optional trailing action
class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
    this.actionLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: c.onSurfaceVariant),
      title: Text(title, style: t.bodyMedium),
      subtitle: Text(
        value,
        style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing ??
          (actionLabel != null
              ? TextButton(onPressed: onTap, child: Text(actionLabel!))
              : null),
      onTap: onTap,
    );
  }
}

/// Action row that navigates or performs an action
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: c.onSurfaceVariant),
      trailing: const Icon(Icons.chevron_right),
      title: Text(title, style: t.bodyLarge),
      onTap: () {
        Feedback.forTap(context);
        onTap?.call();
      },
    );
  }
}

/// Long text row (e.g., About section)
class LongTextTile extends StatelessWidget {
  const LongTextTile({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: c.onSurfaceVariant),
      title: Text(title, style: t.bodyLarge),
      subtitle: Padding(
        padding: const EdgeInsetsDirectional.only(top: 6),
        child: Text(
          text,
          style: t.bodySmall?.copyWith(color: c.onSurfaceVariant),
        ),
      ),
      isThreeLine: true,
    );
  }
}
