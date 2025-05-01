import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:katana_tumor/button/control_buttons.dart';
import 'package:katana_tumor/game/dialog_box.dart';
import 'package:katana_tumor/game/main_menu.dart';
import 'package:katana_tumor/game/my_game.dart';
import 'package:katana_tumor/game/qte_component.dart';
import 'package:katana_tumor/overlays/flashback_overlay.dart';
import 'package:katana_tumor/overlays/glitch_overlay.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
      GameWidget<MyGame>(
        game: MyGame()..pauseEngine(),
        overlayBuilderMap: {
          'glitchOverlay': (context, game) => const GlitchOverlay(),
          'dialogBox': (context, game) => const DialogBox(),
          'mainMenu': (context, game) => MainMenu(game: game as MyGame,),
          'flashbackOverlay': (context, game) => FlashbackOverlay(game: game as MyGame),
          'controlButtons': (context, game) {
            final myGame = game as MyGame;

            if (myGame.player == null) {
              return const SizedBox();
            }

            return ControlButtons(player: myGame.player!);
          },
          'qte': (context, game) => QteOverlay(
            onResult: game.onQteResult,
          ).renderButton(context),
          'gameOver': (context, game) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Oyun Bitti!", style: TextStyle(fontSize: 32)),
                ElevatedButton(
                  onPressed: game.resetGame,
                  child: Text("Tekrar Oyna"),
                ),
              ],
            ),
          ),
        },
        initialActiveOverlays: const ['mainMenu'],
      )
  );
}
