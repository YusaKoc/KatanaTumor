import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:katana_tumor/game/my_game.dart';

class FlashbackOverlay extends StatefulWidget {
  final MyGame game;

  const FlashbackOverlay({super.key, required this.game});

  @override
  State<FlashbackOverlay> createState() => _FlashbackOverlayState();
}

class _FlashbackOverlayState extends State<FlashbackOverlay> with SingleTickerProviderStateMixin {
  double opacity = 0.0;
  String displayedText = '';
  int textIndex = 0;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        opacity = 1.0;
      });
    });


    if (widget.game.currentFlashbackText != null) {
      _ticker = createTicker((Duration elapsed) {
        if (textIndex < widget.game.currentFlashbackText!.length) {
          setState(() {
            displayedText += widget.game.currentFlashbackText![textIndex];
            textIndex++;
          });
        } else {
          _ticker.stop();
        }
      });

      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          if (widget.game.currentFlashbackImage != null)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: opacity,
              child: Image.asset(
                widget.game.currentFlashbackImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.5),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          if (widget.game.currentFlashbackText != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  displayedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
