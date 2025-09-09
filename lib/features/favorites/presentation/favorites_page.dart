import 'package:flutter/material.dart';
import '../../../shared/widgets/atoms.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: const [
        SectionHeader(title: 'Favorites'),
        SizedBox(height: 12),
        _EmptyState(
          icon: Icons.favorite,
          title: 'No favorites yet',
          subtitle: 'Save places and itineraries to find them here.',
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          // أيقونة بلون البراند من الثيم
          Icon(icon, size: 48, color: scheme.primary),

          const SizedBox(height: 12),

          // العنوان من TextTheme (titleLarge ذهبي عندك في الثيم)
          Text(
            title,
            style: theme.textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
