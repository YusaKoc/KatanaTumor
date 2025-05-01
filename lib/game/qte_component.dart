import 'dart:math';
import 'package:flutter/material.dart';

class QteOverlay {
  final void Function(bool success) onResult;
  final Random _random = Random();
  bool _finished = false;

  QteOverlay({required this.onResult});

  Widget renderButton(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final buttonSize = 80.0;


    final x = _random.nextDouble() * (screenSize.width - buttonSize);
    final y = _random.nextDouble() * (screenSize.height - buttonSize);


    Future.delayed(const Duration(seconds: 1), () {
      if (!_finished) {
        _finished = true;
        onResult(false);
      }
    });

    return Stack(
      children: [
        Positioned(
          left: x,
          top: y,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                if (!_finished) {
                  _finished = true;
                  onResult(true);
                }
              },
              child: const Text("KALK", textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }
}
