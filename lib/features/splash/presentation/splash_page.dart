import 'package:flutter/material.dart';
import '../../../shared/widgets/background.dart';
import '../../../shared/widgets/atoms.dart';
import '../../../core/constants/colors.dart';
import '../../auth/state/auth_controller.dart';
import '../../shell/presentation/app_shell.dart';
import '../../auth/presentation/auth_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final ok = await context.read<AuthController>().tryRestore();
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoldenScaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Pyramids',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: kGold, fontSize: 44,
                )),
            const SizedBox(height: 8),
            Text('Egypt Heritage & Smart Trip Planner',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70)),
            const SizedBox(height: 28),
            if (_checking)
              const CircularProgressIndicator()
            else ...[
              GoldButton(
                label: 'Get Started',
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthPage())),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell())),
                child: const Text('Continue as Guest'),
              ),
            ]
          ]),
        ),
      ),
    );
  }
}
