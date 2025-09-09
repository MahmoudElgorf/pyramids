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
  // رجّعنا التابات لـ 2 (Sign in / Sign up)
  late final TabController _tabs = TabController(length: 2, vsync: this);

  // === Sign in ===
  final _formIn = GlobalKey<FormState>();
  final _inEmail = TextEditingController();
  final _inPass = TextEditingController();
  bool _inPassObscure = true;

  // === Sign up ===
  final _formUp = GlobalKey<FormState>();
  final _upName = TextEditingController();
  final _upEmail = TextEditingController();
  final _upPass = TextEditingController();
  bool _upPassObscure = true;

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

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _doSignIn() async {
    if (!_formIn.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().signIn(
        _inEmail.text.trim(),
        _inPass.text.trim(),
      );
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
      await context.read<AuthController>().signUp(
        _upName.text.trim(),
        _upEmail.text.trim(),
        _upPass.text.trim(),
      );
    } catch (e) {
      _toast('$e');
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    }
  }

  void _openResetSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _ResetPasswordSheet(),
    );
  }

  InputDecoration _pwdDecoration({
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
        tooltip: obscure ? 'Show password' : 'Hide password',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoldenScaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Sign in'),
            Tab(text: 'Sign up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          // === Sign in ===
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _SectionHeader(title: 'Sign in'),
              const SizedBox(height: 8),
              Form(
                key: _formIn,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _inEmail,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _inPass,
                      obscureText: _inPassObscure,
                      validator: _validatePass,
                      decoration: _pwdDecoration(
                        label: 'Password',
                        obscure: _inPassObscure,
                        onToggle: () => setState(() => _inPassObscure = !_inPassObscure),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GoldButton(
                      label: _loading ? 'Please wait...' : 'Sign in',
                      onPressed: _loading ? null : _doSignIn,
                    ),
                    // زر Change password يمين تحت زرار Sign in
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _openResetSheet,
                        child: const Text('Change password'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // === Sign up ===
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const _SectionHeader(title: 'Create account'),
              const SizedBox(height: 8),
              Form(
                key: _formUp,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _upName,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _upEmail,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _upPass,
                      obscureText: _upPassObscure,
                      validator: _validatePass,
                      decoration: _pwdDecoration(
                        label: 'Password',
                        obscure: _upPassObscure,
                        onToggle: () => setState(() => _upPassObscure = !_upPassObscure),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GoldButton(
                      label: _loading ? 'Please wait...' : 'Create account',
                      onPressed: _loading ? null : _doSignUp,
                    ),
                  ],
                ),
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

/// Bottom sheet من خطوتين: (1) إدخال الإيميل لإرسال الكود، (2) إدخال التوكن + الباسورد الجديد
class _ResetPasswordSheet extends StatefulWidget {
  const _ResetPasswordSheet();

  @override
  State<_ResetPasswordSheet> createState() => _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends State<_ResetPasswordSheet> {
  int _step = 0;
  bool _loading = false;

  // step 0
  final _formEmail = GlobalKey<FormState>();
  final _email = TextEditingController();

  // step 1
  final _formReset = GlobalKey<FormState>();
  final _token = TextEditingController();
  final _newPass = TextEditingController();
  final _newPass2 = TextEditingController();
  bool _newObscure = true;
  bool _new2Obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _token.dispose();
    _newPass.dispose();
    _newPass2.dispose();
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

  InputDecoration _pwdDecoration({
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      labelText: label,
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }

  Future<void> _requestReset() async {
    if (!_formEmail.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().requestPasswordReset(_email.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset email sent (check inbox)')));
      setState(() => _step = 1);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmReset() async {
    if (!_formReset.currentState!.validate()) return;
    if (_newPass.text.trim() != _newPass2.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _loading = true);
    try {
      await context.read<AuthController>().confirmPasswordReset(
        token: _token.text.trim(),
        newPassword: _newPass.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom + 20;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_step == 0 ? 'Reset password' : 'Enter token & new password',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (_step == 0)
            Form(
              key: _formEmail,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  GoldButton(
                    label: _loading ? 'Please wait...' : 'Send reset link',
                    onPressed: _loading ? null : _requestReset,
                  ),
                ],
              ),
            )
          else
            Form(
              key: _formReset,
              child: Column(
                children: [
                  TextFormField(
                    controller: _token,
                    decoration: const InputDecoration(labelText: 'Token (from email)'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newPass,
                    obscureText: _newObscure,
                    validator: _validatePass,
                    decoration: _pwdDecoration(
                      label: 'New password',
                      obscure: _newObscure,
                      onToggle: () => setState(() => _newObscure = !_newObscure),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _newPass2,
                    obscureText: _new2Obscure,
                    validator: _validatePass,
                    decoration: _pwdDecoration(
                      label: 'Confirm new password',
                      obscure: _new2Obscure,
                      onToggle: () => setState(() => _new2Obscure = !_new2Obscure),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GoldButton(
                    label: _loading ? 'Please wait...' : 'Confirm reset',
                    onPressed: _loading ? null : _confirmReset,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
