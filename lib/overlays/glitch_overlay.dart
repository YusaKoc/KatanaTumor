import 'package:flutter/material.dart';

class GlitchOverlay extends StatelessWidget {
  const GlitchOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        color: Colors.white.withOpacity(0.08),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            1.5, 0, 0, 0, -30,
            0, 1.3, 0, 0, -20,
            0, 0, 1.7, 0, -40,
            0, 0, 0, 1, 0,
          ]),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}
