import 'package:flutter/material.dart';
import '../../../shared/widgets/atoms.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        const SectionHeader(title: 'Smart Trip Planner'),
        const SizedBox(height: 8),

        _PlannerCard(
          title: 'Trip basics',
          child: Column(
            children: const [
              _LabeledField(label: 'Destination(s): e.g. Cairo, Luxor, Aswan'),
              SizedBox(height: 10),
              _LabeledField(label: 'Dates: e.g. 12–18 Oct'),
              SizedBox(height: 10),
              _LabeledField(label: 'Budget: e.g. 700–1000 USD'),
              SizedBox(height: 10),
              _LabeledField(label: 'Travelers: e.g. 2 adults'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _PlannerCard(
          title: 'Interests & pace',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _SelectChip('Pyramids'),
                  _SelectChip('Museums'),
                  _SelectChip('Temples'),
                  _SelectChip('Photography'),
                  _SelectChip('Local Food'),
                  _SelectChip('Shopping'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: _RadioPill(label: 'Relaxed')),
                  SizedBox(width: 8),
                  Expanded(child: _RadioPill(label: 'Balanced')),
                  SizedBox(width: 8),
                  Expanded(child: _RadioPill(label: 'Packed')),
                ],
              ),
              const SizedBox(height: 12),
              GoldButton(label: 'Generate plan (UI)', onPressed: null),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _PlannerCard(
          title: 'Itinerary preview',
          child: Column(
            children: const [
              _DayItem(day: 1, title: 'Cairo – Giza Plateau & Saqqara'),
              _DayItem(day: 2, title: 'Cairo – Egyptian Museum & Khan El Khalili'),
              _DayItem(day: 3, title: 'Luxor – Karnak & Luxor Temple'),
              _DayItem(day: 4, title: 'Luxor – Valley of the Kings & Hatshepsut'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlannerCard extends StatelessWidget {
  const _PlannerCard({required this.title, required this.child});
  final String title; final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(decoration: InputDecoration(labelText: label));
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip(this.label, {this.selected = false});
  final String label; final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) {},
      showCheckmark: false,
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _RadioPill extends StatelessWidget {
  const _RadioPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color(0x33FFD700)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _DayItem extends StatelessWidget {
  const _DayItem({required this.day, required this.title});
  final int day; final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0x33FFD700),
        foregroundColor: Color(0xFFFFD700),
        child: Text(''),
      ),
      title: Row(
        children: [
          const Text('•', style: TextStyle(color: Color(0xFFFFD700))),
          const SizedBox(width: 8),
          Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      ),
      subtitle: const Text('Detailed activities will appear here (design).',
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
