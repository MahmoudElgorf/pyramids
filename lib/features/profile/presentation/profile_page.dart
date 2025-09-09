import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pyramids/shared/widgets/atoms.dart';
import 'package:pyramids/features/auth/presentation/auth_page.dart';
import 'package:pyramids/features/auth/state/auth_controller.dart';
import 'package:pyramids/core/theme/theme_controller.dart';

import 'profile_header.dart';
import 'profile_settings.dart';
import 'theme_picker_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Sign out?'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await context.read<AuthController>().signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
            (_) => false,
      );
    }
  }

  void _pickTheme(BuildContext context) {
    final themeCtl = context.read<ThemeController>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => ThemePickerSheet(
        current: themeCtl.mode,
        onPick: (m) {
          themeCtl.setMode(m);
          Navigator.pop(ctx);
          Feedback.forTap(ctx);
        },
      ),
    );
  }

  Future<void> _editName(BuildContext context, {required String initial}) async {
    final ctl = TextEditingController(text: initial);
    final formKey = GlobalKey<FormState>();
    final auth = context.read<AuthController>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit name'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctl,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              if (v.trim().length < 2) return 'Name too short';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (formKey.currentState?.validate() == true) Navigator.pop(ctx, true);
          }, child: const Text('Save')),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await auth.updateName(ctl.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name updated')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    final auth = context.read<AuthController>();
    final currentCtl = TextEditingController();
    final nextCtl = TextEditingController();
    final confirmCtl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        final viewInsets = MediaQuery.of(ctx).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom, left: 16, right: 16, top: 8),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: currentCtl,
                  decoration: const InputDecoration(labelText: 'Current password'),
                  obscureText: true,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nextCtl,
                  decoration: const InputDecoration(labelText: 'New password'),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 8) return 'At least 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmCtl,
                  decoration: const InputDecoration(labelText: 'Confirm new password'),
                  obscureText: true,
                  validator: (v) => (v != nextCtl.text) ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            Navigator.pop(ctx, true);
                          }
                        },
                        child: const Text('Change'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );

    if (ok != true) return;

    try {
      await auth.changePassword(current: currentCtl.text, next: nextCtl.text);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed. Please sign in again.')),
        );
        await context.read<AuthController>().signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthPage()),
                (_) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Change failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final themeCtl = context.watch<ThemeController>();
    final u = auth.user;

    final scheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        try {
          await auth.refreshProfile();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to refresh: $e')),
            );
          }
        }
      },
      color: scheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          scheme.surface.withOpacity(.0),
                          scheme.surface.withOpacity(.3),
                        ],
                      ),
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: ProfileHeader(
                name: u?.name ?? 'Guest',
                email: u?.email ?? 'tourist@example.com',
                avatarUrl: null, // غيّرها لو عندك avatar في الـuser
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Settings groups
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // ===== Account =====
                  SettingsGroup(
                    title: 'Account',
                    children: [
                      InfoTile(
                        icon: Icons.badge,
                        title: 'Name',
                        value: u?.name ?? 'Guest',
                        actionLabel: 'Edit',
                        onTap: () => _editName(context, initial: u?.name ?? ''),
                      ),
                      InfoTile(
                        icon: Icons.alternate_email,
                        title: 'Email',
                        value: u?.email ?? 'tourist@example.com',
                      ),
                      ActionTile(
                        icon: Icons.lock_reset,
                        title: 'Change password',
                        onTap: () => _changePassword(context),
                      ),
                    ],
                  ),

                  // ===== General =====
                  const SettingsGroup(
                    title: 'General',
                    children: [
                      SettingTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: 'English / العربية',
                      ),
                    ],
                  ),

                  // ===== Appearance =====
                  SettingsGroup(
                    title: 'Appearance',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.dark_mode),
                        trailing: const Icon(Icons.chevron_right),
                        title: Row(
                          children: [
                            Icon(Icons.verified, color: scheme.primary),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text('Theme',
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 36),
                          child: Text(
                            themeCtl.mode.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                        onTap: () => _pickTheme(context),
                      ),
                    ],
                  ),

                  // ===== About =====
                  const SettingsGroup(
                    title: 'About',
                    children: [
                      LongTextTile(
                        icon: Icons.info,
                        title: 'About Pyramids',
                        text:
                        'Pyramids is a modern app for planning heritage trips in Egypt. '
                            'It provides curated site lists, customizable routes, and quick cultural notes '
                            'all within a clean design that supports both light and dark modes.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  GoldButton(label: 'Sign out', onPressed: () => _logout(context)),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
