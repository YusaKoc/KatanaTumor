import 'package:flutter/material.dart';
import 'package:katana_tumor/game/player.dart';

class ControlButtons extends StatelessWidget {
  final Player player;

  const ControlButtons({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Positioned(
        bottom: 30,
        left: 30,
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () => player.moveUp(),
              child: const Icon(Icons.arrow_upward,color: Colors.purple,),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () => player.moveDown(),
              child: const Icon(Icons.arrow_downward,color: Colors.purple,),
            ),
          ],
        ),
      ),
        Positioned(
          bottom: 30,
          right: 30,
          child: ElevatedButton(
            onPressed: () => player.performAttack(),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(20),
            ),
            child: const Text(
              "A",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.purple),
            ),
          ),
        ),
    ],
    );
  }
}
