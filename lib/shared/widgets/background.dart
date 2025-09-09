import 'package:flutter/material.dart';

class GoldenScaffold extends StatelessWidget {
  const GoldenScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.fab,
    this.backgroundAsset,
    this.imageOpacity,
    this.extendBodyBehindAppBar = true,
    this.showOverlayGradient = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? fab;

  final String? backgroundAsset;
  final double? imageOpacity;
  final bool extendBodyBehindAppBar;
  final bool showOverlayGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final scaffoldBg = theme.scaffoldBackgroundColor;

    final bgOpacity = imageOpacity ?? (isDark ? 0.12 : 0.06);

    final topGrad = scheme.surface.withOpacity(isDark ? .40 : .20);
    final bottomGrad = scheme.surface.withOpacity(isDark ? .78 : .42);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scaffoldBg,
                image: DecorationImage(
                  image: AssetImage(
                    backgroundAsset ?? 'assets/images/egypt_bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  opacity: bgOpacity,
                ),
              ),
              child: showOverlayGradient
                  ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [topGrad, bottomGrad],
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),

          Positioned.fill(
            child: SafeArea(child: body),
          ),
        ],
      ),
      floatingActionButton: fab,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
