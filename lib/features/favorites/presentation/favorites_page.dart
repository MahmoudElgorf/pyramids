import 'package:flutter/material.dart';
import '../../../shared/widgets/atoms.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder: فضّل تكمّلها لاحقًا بربط حقيقي بحفظ الأماكن/الخطط
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const SectionHeader(title: 'Favorites'),
        const SizedBox(height: 12),
        const _EmptyState(
          icon: Icons.favorite,
          title: 'No favorites yet',
          subtitle: 'Save places and itineraries to find them here.',
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.subtitle});
  final IconData icon; final String title; final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFFFFD700)),
          const SizedBox(height: 12),
          Text(title,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
