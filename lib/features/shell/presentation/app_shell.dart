import 'package:flutter/material.dart';
import '../../../shared/widgets/background.dart';
import '../../explore/presentation/explore_page.dart';
import '../../plan/presentation/plan_page.dart';
import '../../itineraries/presentation/itineraries_page.dart';
import '../../favorites/presentation/favorites_page.dart';
import '../../profile/presentation/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      ExplorePage(),
      PlanPage(),
      ItinerariesPage(),
      FavoritesPage(),
      ProfilePage(),
    ];
    final labels = ['Explore', 'Plan', 'Itineraries', 'Favorites', 'Profile'];
    final icons = const [Icons.explore, Icons.auto_awesome, Icons.event_note, Icons.favorite, Icons.person];

    return GoldenScaffold(
      appBar: AppBar(title: Text(labels[_index])),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (int i = 0; i < labels.length; i++)
            NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
        ],
      ),
    );
  }
}
