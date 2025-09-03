import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/atoms.dart';
import '../../auth/state/auth_controller.dart';
import '../../splash/presentation/splash_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthController>().signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashPage()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final u = auth.user;
    return RefreshIndicator(
      onRefresh: () => auth.refreshProfile(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0x33FFD700),
              backgroundImage: (u?.avatar != null && u!.avatar!.isNotEmpty) ? NetworkImage(u.avatar!) : null,
              child: (u?.avatar == null || (u!.avatar!).isEmpty) ? const Icon(Icons.person, color: Color(0xFFFFD700)) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u?.name ?? 'Guest', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(u?.email ?? 'tourist@example.com', style: const TextStyle(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
          ]),
          const SizedBox(height: 16),
          Card(child: Column(children: const [
            _SettingTile(icon: Icons.language, title: 'Language', subtitle: 'English / العربية'),
            Divider(height: 1, color: Color(0x33FFFFFF)),
            _SettingTile(icon: Icons.dark_mode, title: 'Appearance', subtitle: 'Dark + Gold'),
            Divider(height: 1, color: Color(0x33FFFFFF)),
            _SettingTile(icon: Icons.notifications, title: 'Notifications', subtitle: 'Muted'),
          ])),
          const SizedBox(height: 16),
          Card(child: Column(children: const [
            _SettingTile(icon: Icons.info, title: 'About Pyramids', subtitle: 'Heritage & Trip planner UI'),
            Divider(height: 1, color: Color(0x33FFFFFF)),
            _SettingTile(icon: Icons.privacy_tip, title: 'Privacy & Terms', subtitle: 'Design only'),
          ])),
          const SizedBox(height: 24),
          GoldButton(label: 'Sign out', onPressed: () => _logout(context)),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon; final String title; final String subtitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chevron_right, color: Colors.white70),
      title: Row(children: [
        const Icon(Icons.verified, color: Color(0xFFFFD700)), const SizedBox(width: 10),
        Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]),
      subtitle: const Padding(
        padding: EdgeInsetsDirectional.only(start: 36),
        child: Text('Design only', style: TextStyle(color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      onTap: () {},
    );
  }
}
