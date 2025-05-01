import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:katana_tumor/game/menu_background_game.dart';
import 'package:katana_tumor/game/my_game.dart';
import 'package:flame/widgets.dart';

class MainMenu extends StatelessWidget {
  final MyGame game;

  const MainMenu({super.key, required this.game});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        GameWidget(game: MenuBackgroundGame()),
        Container(
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Image.asset("assets/images/title.png",width: context.sized.dynamicWidth(0.2),),
              SizedBox(
                width: 150,
                height: 150,
                child: SpriteAnimationWidget(
                  animation: game.idleAnimation,
                  animationTicker: SpriteAnimationTicker(game.idleAnimation),
                ),
              ),
              const SizedBox(height: 12),


              SizedBox(
                width: context.sized.dynamicWidth(0.6),
                height: context.sized.dynamicHeight(0.1),
                child: ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('mainMenu');
                    game.playIntroScene();
                    game.startGame();
                    game.overlays.add('controlButtons');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text(
                    "BAŞLA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
    );
  }
}
