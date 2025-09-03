import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class GoldenScaffold extends StatelessWidget {
  const GoldenScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.fab,
  });
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: kDark,
                image: DecorationImage(
                  image: AssetImage('assets/egypt_bg.png'),
                  fit: BoxFit.cover,
                  opacity: 0.12,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Color(0x661F1F1F), Color(0xB31F1F1F)],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(child: SafeArea(child: body)),
        ],
      ),
      floatingActionButton: fab,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
