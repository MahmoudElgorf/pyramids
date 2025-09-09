import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = await ThemeController.init();
  runApp(
    ChangeNotifierProvider.value(
      value: themeController,
      child: const PyramidsTouristApp(),
    ),
  );
}
