import 'package:flutter/material.dart';
import '../../../shared/widgets/atoms.dart';

class ItinerariesPage extends StatelessWidget {
  const ItinerariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: const [
        SectionHeader(title: 'Saved itineraries'),
        SizedBox(height: 8),
        _SavedItineraryCard(
          title: 'Cairo & Luxor – 5 days',
          tags: ['History', 'Museums', 'Photography'],
        ),
        _SavedItineraryCard(
          title: 'Upper Egypt highlights – 3 days',
          tags: ['Temples', 'Nile'],
        ),
        _SavedItineraryCard(
          title: 'Giza & Saqqara – 2 days',
          tags: ['Pyramids'],
        ),
      ],
    );
  }
}

class _SavedItineraryCard extends StatelessWidget {
  const _SavedItineraryCard({required this.title, required this.tags});
  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [for (final t in tags) OutlinedPill(label: t)],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GoldButton(label: 'Open', onPressed: () {}),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
