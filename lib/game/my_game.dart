import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:katana_tumor/game/enemy.dart';
import 'package:katana_tumor/game/player.dart';
import 'package:katana_tumor/game/obstacle.dart';
import 'package:katana_tumor/game/scrolling_path.dart';
import 'package:katana_tumor/game/scrolling_ground.dart';

class MyGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  Player? player;
  late final SpriteAnimation idleAnimation;
  final AudioPlayer backgroundMusicPlayer = AudioPlayer();

  bool isGlitching = false;

  late Timer flashbackTimer;
  final List<Map<String, String>> flashbacks = [
    {
      'image': 'assets/images/flash1.png',
      'text':"Çocukluğum zor şartlardaki köyde kılıç sallayarak geçti. O zamanlar kendimi savunmalıydım..",
    },
    {
      'image': 'assets/images/flash2.png',
      'text': "Köydekiler öleceğimi düşündü ama ben direndim",
    },
    {
      'image': 'assets/images/flash3.png',
      'text': "Köyden ayrılıp ölmemek için şifa aramalıydım.",
    },
    {
      'image': 'assets/images/flash4.png',
      'text': "'Garip Bozuk Bir Varlık' beni buldu ve yıllarım karşılığında tedavi yolumu öğrendim",
    },
    {
      'image': 'assets/images/flash5.png',
      'text': "BURAYA KAÇINCI KERE, NE ZAMAN, NİYE GELDİĞİMİ BİLMİYORUM AMA SAVAŞMALIYIM.",
    },
  ];

  int currentFlashbackIndex = 0;


  final Random _flashbackRandom = Random();
  String? currentFlashbackImage;


  String? currentFlashbackText;






  late Timer enemySpawnTimer;
  double enemySpawnInterval = 2.5;
  final double minEnemySpawnInterval = 0.5;

  final Random _rng = Random();
  final Random _enemyRandom = Random();

  late Timer obstacleTimer;
  late Timer speedTimer;

  final Random _random = Random();


  double scrollSpeed = 100;
  double obstacleSpawnInterval = 2.5;
  final double initialObstacleSpawnInterval = 2.5;
  final double minSpawnInterval = 0.7;
  final double maxScrollSpeed = 800;


  double laneHeight = 0;
  double roadTopY = 0;
  final double roadHeightRatio = 0.7;


  int score = 0;
  late TextComponent scoreText;
  double scoreTimer = 0;

  bool isQteActive = false;

  @override
  Future<void> onLoad() async {

    await backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.play(AssetSource('audio/loop_music.mp3'));

    flashbackTimer = Timer(randomFlashbackDelay(), onTick: showFlashback, repeat: true);
    flashbackTimer.start();



    enemySpawnTimer = Timer(enemySpawnInterval, repeat: true, onTick: spawnEnemy);
    enemySpawnTimer.start();

    final image = await images.load('samuray_sheet.png');

    idleAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2(42, 53),
        texturePosition: Vector2(0, 0),
      ),
    );


    final screenWidth = size.x;
    final screenHeight = size.y;

    final roadHeight = screenHeight * roadHeightRatio;
    laneHeight = roadHeight / 3;
    roadTopY = screenHeight - roadHeight;


    add(ScrollingBackground());
    add(ScrollingPath(speed: scrollSpeed));


    score = 0;
    scoreText = TextComponent(
      text: 'Skor: 0',
      position: Vector2(screenWidth - 140, 20),
      anchor: Anchor.topLeft,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);


    player = Player(
      laneHeight: laneHeight,
      xPosition: screenWidth * 0.2,
      roadTopY: roadTopY,
    );
    add(player!);


    speedTimer = Timer(10, repeat: true, onTick: () {
      scrollSpeed = (scrollSpeed * 1.15).clamp(0, maxScrollSpeed);
      obstacleSpawnInterval = (obstacleSpawnInterval * 0.85).clamp(minSpawnInterval, 10);

      obstacleTimer.stop();
      obstacleTimer = Timer(obstacleSpawnInterval, repeat: true, onTick: spawnObstacle);
      obstacleTimer.start();

      print("Yeni scrollSpeed: $scrollSpeed, spawnInterval: $obstacleSpawnInterval");
    });
    speedTimer.start();


    obstacleTimer = Timer(obstacleSpawnInterval, repeat: true, onTick: spawnObstacle);
    obstacleTimer.start();
  }

  void increaseScore(int amount) {
    score += amount;
    scoreText.text = 'Skor: $score';
  }

  double randomFlashbackDelay() {
    return 20 + _flashbackRandom.nextDouble() * 10;
  }

  void showFlashback() {
    if (currentFlashbackIndex >= flashbacks.length) {

      return;
    }

    final flashback = flashbacks[currentFlashbackIndex];

    overlays.add('flashbackOverlay');
    currentFlashbackImage = flashback['image'];
    currentFlashbackText = flashback['text'];

    pauseEngine();

    Future.delayed(const Duration(seconds: 6), () {
      overlays.remove('flashbackOverlay');
      currentFlashbackImage = null;
      currentFlashbackText = null;
      resumeEngine();

      currentFlashbackIndex++;


      flashbackTimer = Timer(randomFlashbackDelay(), onTick: showFlashback, repeat: false);
      flashbackTimer.start();
    });
  }








  void spawnEnemy() {
    final y = roadTopY + laneHeight * _enemyRandom.nextInt(3) + laneHeight / 2;

    final enemy = Enemy(
      position: Vector2(size.x + 64, y),
      size: Vector2(64, 64),
      speed: scrollSpeed + 100,
    );
    add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    obstacleTimer.update(dt);
    speedTimer.update(dt);
    enemySpawnTimer.update(dt);
    flashbackTimer.update(dt);

    if (!isQteActive) {
      scoreTimer += dt;
      if (scoreTimer >= 1.0) {
        score++;
        scoreText.text = 'Skor: $score';
        scoreTimer = 0;
      }
    }


    double newInterval = (2.5 - (scrollSpeed - 100) / 400).clamp(minEnemySpawnInterval, 2.5);

    if (newInterval != enemySpawnInterval) {
      enemySpawnInterval = newInterval;
      enemySpawnTimer.stop();
      enemySpawnTimer = Timer(enemySpawnInterval, repeat: true, onTick: spawnEnemy);
      enemySpawnTimer.start();
    }

  }

  void spawnObstacle() {
    final laneIndex = _random.nextInt(3);
    final laneY = roadTopY + laneHeight * laneIndex + laneHeight / 2 - 32;

    final obstacle = Obstacle(
      laneIndex: laneIndex,
      position: Vector2(size.x + 64, laneY),
      size: Vector2(64, 64),
    );
    add(obstacle);
  }

  void showQte() {
    if (isQteActive) return;

    isQteActive = true;
    pauseEngine();
    overlays.add('qte');
  }

  void onQteResult(bool success) {
    overlays.remove('qte');
    isQteActive = false;
    player?.hasCollided = false;

    if (success) {

      bool hasPenalty = _rng.nextBool();

      if (hasPenalty) {
        score -= 10;
        if (score < 0) score = 0;
        scoreText.text = 'Skor: $score';
      } else {
        showScoreSecuredImage();
      }

      resumeEngine();
    } else {
      player?.die();
    }
  }




  void gameOver() {
    pauseEngine();
    overlays.add('gameOver');
  }

  void resetGame() {
    overlays.remove('gameOver');

    isQteActive = false;
    scrollSpeed = 100;
    obstacleSpawnInterval = initialObstacleSpawnInterval;
    score = 0;
    scoreTimer = 0;
    isGlitching = false;
    currentFlashbackImage = null;
    currentFlashbackText = null;
    currentFlashbackIndex = 0;
    flashbackTimer.stop();

    obstacleTimer.stop();
    enemySpawnTimer.stop();
    speedTimer.stop();
    flashbackTimer.stop();
    children.clear();


    add(ScrollingBackground());
    add(ScrollingPath(speed: scrollSpeed));


    scoreText = TextComponent(
      text: 'Skor: 0',
      position: Vector2(size.x - 140, 20),
      anchor: Anchor.topLeft,
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);


    player = Player(
      laneHeight: laneHeight,
      xPosition: size.x * 0.2,
      roadTopY: roadTopY,
    );
    add(player!);

    obstacleTimer = Timer(obstacleSpawnInterval, repeat: true, onTick: spawnObstacle)..start();
    enemySpawnTimer = Timer(enemySpawnInterval, repeat: true, onTick: spawnEnemy)..start();
    speedTimer = Timer(10, repeat: true, onTick: () {
      scrollSpeed = (scrollSpeed * 1.15).clamp(0, maxScrollSpeed);
      obstacleSpawnInterval = (obstacleSpawnInterval * 0.85).clamp(minSpawnInterval, 10);
      obstacleTimer.stop();
      obstacleTimer = Timer(obstacleSpawnInterval, repeat: true, onTick: spawnObstacle)..start();
    })..start();


    flashbackTimer = Timer(randomFlashbackDelay(), onTick: showFlashback, repeat: false)..start();
    resumeEngine();
  }


  void showScoreSecuredImage() async {
    final sprite = await Sprite.load('player_secured.png');

    final component = SpriteComponent(
      sprite: sprite,
      size: Vector2(400, 240),
      anchor: Anchor.center,
      position: size / 2,
      priority: 200,
    );

    add(component);

    Future.delayed(const Duration(seconds: 2), () {
      component.removeFromParent();
    });
  }

  void startGame() {

    onLoad();
    resumeEngine();
  }


  void playIntroScene() async {
    overlays.add('dialogBox');

    await Future.delayed(const Duration(seconds: 6));

    overlays.remove('dialogBox');
    overlays.add('controlButtons');
    resumeEngine();
  }



}


