import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/presentation/splash_page.dart';
import '../features/auth/state/auth_controller.dart';
import '../data/repositories/auth_repository.dart';

class PyramidsTouristApp extends StatelessWidget {
  const PyramidsTouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(AuthRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const SplashPage(),
      ),
    );
  }
}
