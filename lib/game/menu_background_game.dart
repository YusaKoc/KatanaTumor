import 'package:flame/game.dart';
import 'package:katana_tumor/game/scrolling_ground.dart';
import 'package:katana_tumor/game/scrolling_path.dart';

class MenuBackgroundGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(ScrollingBackground());
    add(ScrollingPath(speed: 30));
  }
}
