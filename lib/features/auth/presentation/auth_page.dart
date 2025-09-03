import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/background.dart';
import '../../../shared/widgets/atoms.dart';
import '../../shell/presentation/app_shell.dart';
import '../state/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  final _formIn = GlobalKey<FormState>();
  final _inEmail = TextEditingController();
  final _inPass = TextEditingController();

  final _formUp = GlobalKey<FormState>();
  final _upName = TextEditingController();
  final _upEmail = TextEditingController();
  final _upPass = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _tabs.dispose();
    _inEmail.dispose(); _inPass.dispose();
    _upName.dispose(); _upEmail.dispose(); _upPass.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
    if (!ok) return 'Invalid email';
    return null;
  }

  String? _validatePass(String? v) {
    final s = (v ?? '').trim();
    if (s.length < 6) return 'Min 6 characters';
    return null;
  }

  String? _validateName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Full name is required';
    return null;
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _doSignIn() async {
    if (!_formIn.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().signIn(_inEmail.text.trim(), _inPass.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    } catch (e) {
      _toast('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _doSignUp() async {
    if (!_formUp.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().signUp(_upName.text.trim(), _upEmail.text.trim(), _upPass.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    } catch (e) {
      _toast('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoldenScaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        bottom: TabBar(controller: _tabs, tabs: const [Tab(text: 'Sign in'), Tab(text: 'Sign up')]),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // Sign in
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _SectionHeader(title: 'Sign in'),
              const SizedBox(height: 8),
              Form(
                key: _formIn,
                child: Column(children: [
                  TextFormField(controller: _inEmail, decoration: const InputDecoration(labelText: 'Email'), validator: _validateEmail),
                  const SizedBox(height: 10),
                  TextFormField(controller: _inPass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: _validatePass),
                  const SizedBox(height: 16),
                  GoldButton(label: _loading ? 'Please wait...' : 'Sign in', onPressed: _loading ? null : _doSignIn),
                ]),
              ),
            ],
          ),
          // Sign up
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _SectionHeader(title: 'Create account'),
              const SizedBox(height: 8),
              Form(
                key: _formUp,
                child: Column(children: [
                  TextFormField(controller: _upName, decoration: const InputDecoration(labelText: 'Full name'), validator: _validateName),
                  const SizedBox(height: 10),
                  TextFormField(controller: _upEmail, decoration: const InputDecoration(labelText: 'Email'), validator: _validateEmail),
                  const SizedBox(height: 10),
                  TextFormField(controller: _upPass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: _validatePass),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: const [
                      _SelectChip('History'), _SelectChip('Museums'), _SelectChip('Photography'),
                      _SelectChip('Food'), _SelectChip('Adventure'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GoldButton(label: _loading ? 'Please wait...' : 'Create account', onPressed: _loading ? null : _doSignUp),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis);
}

class _SelectChip extends StatelessWidget {
  const _SelectChip(this.label, {this.selected = false});
  final String label; final bool selected;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) {},
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      showCheckmark: false,
    );
  }
}
