import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final AudioPlayer _deathPlayer = AudioPlayer();
final AudioPlayer _dash = AudioPlayer();

void playAttackSound() async {
  await _audioPlayer.play(AssetSource('audio/attack_sound.mp3'));
}

void playDeathSound() async {
  await _deathPlayer.play(AssetSource('audio/death_sound.mp3'));
}

void playDashSound() async {
  await _deathPlayer.play(AssetSource('audio/dash_glitch.mp3'));
}



