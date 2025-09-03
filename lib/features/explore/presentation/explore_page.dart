import 'package:flutter/material.dart';
import '../../../shared/widgets/atoms.dart';
import '../../../shared/demo/demo_data.dart';
import '../../../core/constants/colors.dart';
import '../../../data/repositories/poi_repository.dart';
import '../../../data/models/poi.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _repo = PoiRepository();
  List<Poi>? _pois;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await _repo.list(city: 'Giza', q: 'pyramid');
      if (!mounted) return;
      setState(() { _pois = rows; _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const SectionHeader(title: 'Top Archaeological Areas'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in const ['Giza', 'Saqqara', 'Dahshur', 'Karnak', 'Valley of the Kings', 'Philae'])
                const Padding(padding: EdgeInsets.only(right: 8), child: OutlinedPill(label: '')),
            ].asMap().entries.map((e) {
              final labels = ['Giza','Saqqara','Dahshur','Karnak','Valley of the Kings','Philae'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedPill(label: labels[e.key]),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
        else if ((_pois ?? []).isNotEmpty) ...[
          for (final p in _pois!) _PlaceCard(
              name: p.name, location: p.city, era: p.type, period: p.bestTimeOfDay, description: p.descriptionShort),
        ] else ...[
          for (final p in demoSites)
            _PlaceCard(name: p.name, location: p.location, era: p.era, period: p.period, description: p.description),
        ],
      ],
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.name, required this.location, required this.era, required this.period, required this.description});
  final String name, location, era, period, description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showDialog(context: context, builder: (_) => _PlaceDialog(name: name, location: location, era: era, description: description)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: const Color(0x221F1F1F),
                width: 84, height: 84,
                child: const Icon(Icons.museum, size: 36, color: kGold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Wrap(spacing: 8, runSpacing: 4, children: [
                  InfoChip(icon: Icons.place, label: location),
                  InfoChip(icon: Icons.history, label: era),
                  InfoChip(icon: Icons.timelapse, label: period),
                ]),
                const SizedBox(height: 8),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border))
          ]),
        ),
      ),
    );
  }
}

class _PlaceDialog extends StatelessWidget {
  const _PlaceDialog({required this.name, required this.location, required this.era, required this.description});
  final String name, location, era, description;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 420),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                InfoChip(icon: Icons.place, label: location),
                InfoChip(icon: Icons.history, label: era),
                const InfoChip(icon: Icons.star, label: 'Must-see'),
              ]),
              const SizedBox(height: 12),
              Text(description),
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerRight,
                  child: GoldButton(label: 'Add to plan', onPressed: () => Navigator.pop(context))),
            ]),
          ),
        ),
      ),
    );
  }
}
