import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

class ScrollingBackground extends Component with HasGameRef<FlameGame> {

  late Sprite normalSprite;
  late Sprite glitchSprite;
  bool isGlitching = false;
  double glitchTimer = 0;
  double glitchDuration = 1.0;
  double glitchCooldown = 20.0;
  double glitchElapsed = 0;


  late Sprite bgSprite;
  final double scrollSpeed;
  double x1 = 0;
  double x2 = 0;
  late double width;

  ScrollingBackground({this.scrollSpeed = 100});

  @override
  Future<void> onLoad() async {
    normalSprite = await Sprite.load('city2.png');
    glitchSprite = await Sprite.load(
        'city2_glitch.jpg');
    bgSprite = normalSprite;

    width = gameRef.size.x;
    x2 = width;
  }

  @override
  void render(Canvas canvas) {
    bgSprite.render(canvas, position: Vector2(x1, 0), size: gameRef.size);
    bgSprite.render(canvas, position: Vector2(x2, 0), size: gameRef.size);
  }

  @override
  void update(double dt) {
    super.update(dt);

    glitchElapsed += dt;

    if (!isGlitching && glitchElapsed >= glitchCooldown) {

      isGlitching = true;
      glitchElapsed = 0;
      bgSprite = glitchSprite;

      gameRef.overlays.add('glitchOverlay');
    }

    if (isGlitching) {
      glitchTimer += dt;
      if (glitchTimer >= glitchDuration) {

        isGlitching = false;
        glitchTimer = 0;
        bgSprite = normalSprite;

        gameRef.overlays.remove('glitchOverlay');
      }
    }

    x1 -= scrollSpeed * dt;
    x2 -= scrollSpeed * dt;

    if (x1 + width < 0) x1 = x2 + width;
    if (x2 + width < 0) x2 = x1 + width;
  }
}
