import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme.dart';

/// Logo Noot, dibaca dari `assets/noot app logo.png`.
class NootLogo extends StatelessWidget {
  const NootLogo({super.key, this.size = 96, this.radius = 0});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        kLogoAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: (size * 3).round(),
        filterQuality: FilterQuality.medium,
        semanticLabel: 'Logo Noot',
        errorBuilder: (_, __, ___) => SizedBox.square(
          dimension: size,
          child: const ColoredBox(color: NootColors.navy),
        ),
      ),
    );
  }
}
