import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'my_game.dart';

class ScrollingPath extends Component with HasGameRef<MyGame> {
  late Sprite bgSprite;
  late double speed;

  double x1 = 0;
  double x2 = 0;
  late double y;
  late double width;
  late double height;

  ScrollingPath({required this.speed});

  @override
  Future<void> onLoad() async {
    bgSprite = await Sprite.load('path2.png');
    width = gameRef.size.x;
    height = gameRef.size.y * gameRef.roadHeightRatio;
    y = gameRef.size.y - height;
    x2 = width;
  }

  @override
  void render(Canvas canvas) {
    bgSprite.render(canvas, position: Vector2(x1, y), size: Vector2(width, height));
    bgSprite.render(canvas, position: Vector2(x2, y), size: Vector2(width, height));
  }

  @override
  void update(double dt) {
    final currentSpeed = gameRef.scrollSpeed;
    x1 -= currentSpeed * dt;
    x2 -= currentSpeed * dt;

    if (x1 + width < 0) x1 = x2 + width;
    if (x2 + width < 0) x2 = x1 + width;
  }
}
