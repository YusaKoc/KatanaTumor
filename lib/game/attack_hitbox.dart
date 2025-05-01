import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:katana_tumor/game/enemy.dart';

class AttackHitbox extends PositionComponent with CollisionCallbacks {
  AttackHitbox({required Vector2 position})
      : super(position: position, size: Vector2(40, 40), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()..collisionType = CollisionType.active);

  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Enemy) {
      other.kill();
      removeFromParent();
    }
  }

}
