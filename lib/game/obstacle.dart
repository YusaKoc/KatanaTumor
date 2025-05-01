import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:katana_tumor/game/my_game.dart';

class Obstacle extends SpriteComponent with HasGameRef<MyGame>,CollisionCallbacks {

  int laneIndex;

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.laneIndex,
  }) : super(position: position, size: size, priority: 1);



  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('obstacle.png');
    add(CircleHitbox.relative(0.5, parentSize: size)..collisionType = CollisionType.inactive);
  }


  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.scrollSpeed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
