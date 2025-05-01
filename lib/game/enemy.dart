import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:katana_tumor/game/my_game.dart';
import 'dart:math';

import 'package:katana_tumor/game/player.dart';


class Enemy extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef {
  bool hasGlitched = false;
  bool isDead = false;
  final double speed;
  final Random _random = Random();
  bool willGlitch = false;
  SpriteComponent? alertMark;


  Enemy({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('enemy.png');

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );


    add(CircleHitbox.relative(0.7, parentSize: size)..collisionType = CollisionType.active);

    willGlitch = _random.nextDouble() < 0.25;

    if (willGlitch) {

      Future.delayed(const Duration(seconds: 1), showAlert);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDead) return;

    position.x -= speed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }


  void glitchMove() {

    final double laneHeight = (gameRef as MyGame).laneHeight;
    final double roadTopY = (gameRef as MyGame).roadTopY;

    final randomLane = _random.nextInt(3);

    final newY = roadTopY + laneHeight * randomLane + laneHeight / 2;

    position.y = newY;


    add(
      MoveByEffect(
        Vector2(5, 0),
        EffectController(duration: 0.1, reverseDuration: 0.1, repeatCount: 5),
      ),
    );
  }


  void kill() {
    if (isDead) return;
    isDead = true;
    removeFromParent();

    (gameRef as MyGame).increaseScore(10);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player && !isDead) {
      other.die();
    }
  }


  void showAlert() async {

    final sprite = await Sprite.load('alertmark.png');


    alertMark = SpriteComponent(
      sprite: sprite,
      size: Vector2(24, 24),
      position: Vector2(size.x / 2, -20),
      anchor: Anchor.center,
    );

    add(alertMark!);


    Future.delayed(const Duration(milliseconds: 600), () {
      if (!isDead && isMounted) {
        glitchMove();
        alertMark?.removeFromParent();
      }
    });
  }


}


