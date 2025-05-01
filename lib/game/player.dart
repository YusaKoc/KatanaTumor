import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:katana_tumor/game/attack_hitbox.dart';
import 'package:katana_tumor/game/audio_fun.dart';
import 'package:katana_tumor/game/enemy.dart';
import 'package:katana_tumor/game/my_game.dart';
import 'package:katana_tumor/game/obstacle.dart';

enum PlayerAnimationState { run, moveUp, moveDown, attack, idle,death }

class Player extends SpriteAnimationGroupComponent<PlayerAnimationState>
    with HasGameRef<MyGame>, KeyboardHandler, CollisionCallbacks {
  final double laneHeight;
  final double xPosition;
  final double roadTopY;

  bool isImmune = false;



  bool hasCollided = false;
  int currentLane = 1;

  Player({
    required this.laneHeight,
    required this.xPosition,
    required this.roadTopY,
  }) : super(size: Vector2(128, 128));

  @override
  Future<void> onLoad() async {


    size = Vector2(100, 100);
    final image = await gameRef.images.load('samuray_sheet.png');

    animations = {
      PlayerAnimationState.run: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.1,
          textureSize: Vector2(42, 40),
          texturePosition: Vector2(0, 64*1),
        ),
      ),
      PlayerAnimationState.idle: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(42, 53),
          texturePosition: Vector2(0, 0),
        ),
      ),
      PlayerAnimationState.attack: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(42, 64),
          texturePosition: Vector2(42, 53*2),
        ),
      ),
      PlayerAnimationState.moveUp: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.08,
          textureSize: Vector2(42, 64),
          texturePosition: Vector2(30, 159),
        ),
      ),
      PlayerAnimationState.moveDown: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.08,
          textureSize: Vector2(42, 64),
          texturePosition: Vector2(30, 53*4),
        ),
      ),
      PlayerAnimationState.death: SpriteAnimation.fromFrameData(
        image,
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(42, 64),
          texturePosition: Vector2(0, 265),
        ),
      ),
    };

    current = PlayerAnimationState.run;
    anchor = Anchor.center;
    position = Vector2(
      xPosition,
      roadTopY + laneHeight * currentLane + laneHeight / 2,
    );

    add(CircleHitbox.relative(0.7, parentSize: size)..collisionType = CollisionType.active);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.children.isEmpty) return;

    for (final comp in gameRef.children) {
      if (!isImmune && comp is Obstacle) {
        if (!hasCollided &&
            comp.laneIndex == currentLane &&
            (position.x - comp.position.x).abs() < 30) {
          hasCollided = true;
          comp.removeFromParent();
          gameRef.showQte();
        }
      }

      if (!isImmune && comp is Enemy) {
        if ((position.x - comp.position.x).abs() < 30 &&
            (position.y - comp.position.y).abs() < 10) {
          die();
        }
      }
    }
  }




  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp && currentLane > 0) {
        currentLane--;
        updateLanePosition();
        playMoveAnimation(PlayerAnimationState.moveUp);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown && currentLane < 2) {
        currentLane++;
        updateLanePosition();
        playMoveAnimation(PlayerAnimationState.moveDown);
      }
    }
    return true;
  }

  void playMoveAnimation(PlayerAnimationState direction) {
    current = direction;


    Future.delayed(const Duration(milliseconds: 300), () {

      if (isMounted) {
        current = PlayerAnimationState.run;
      }
    });
  }

  void updateLanePosition() {
    final targetY = roadTopY + laneHeight * currentLane + laneHeight / 2;
    position.y = targetY;


    isImmune = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      isImmune = false;
    });
  }


 /* @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Enemy) {
      die();
    }
  }

  */



  void moveUp() {
    if (currentLane > 0) {
      currentLane--;
      updateLanePosition();
      playMoveAnimation(PlayerAnimationState.moveUp);
    }

  }

  void moveDown() {
    if (currentLane < 2) {
      currentLane++;
      updateLanePosition();
      playMoveAnimation(PlayerAnimationState.moveDown);
    }

  }

  void performAttack() {
    playAttackSound();

    if (current == PlayerAnimationState.attack) return;

    current = PlayerAnimationState.attack;


    final attackHitbox = AttackHitbox(
      position: Vector2(position.x + size.x * 0.5, position.y),
    );

    parent?.add(attackHitbox);

    Future.delayed(const Duration(milliseconds: 300), () {
      attackHitbox.removeFromParent();
      current = PlayerAnimationState.run;
    });
  }

  void die() {
    if (current == PlayerAnimationState.death) return;

    current = PlayerAnimationState.death;
    playDeathSound();


    Future.delayed(const Duration(milliseconds: 1200), () {
      gameRef.gameOver();
    });
  }




}


