import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pyramids/core/theme/app_theme.dart';
import 'package:pyramids/core/theme/theme_controller.dart';

import 'package:pyramids/data/api/api_client.dart';
import 'package:pyramids/data/repositories/auth_repository.dart';

import 'package:pyramids/features/auth/state/auth_controller.dart';
import 'package:pyramids/features/auth/presentation/auth_page.dart';

class PyramidsTouristApp extends StatelessWidget {
  const PyramidsTouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(AuthRepository(ApiClient.I))..loadMe(),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: theme.mode,
            home: const AuthPage(),
          );
        },
      ),
    );
  }
}
