import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts flutterTts = FlutterTts();
  static Future textToSpeech(String textForSpeech) async {
    await flutterTts.setSpeechRate(0.6);
    flutterTts.speak(textForSpeech);
  }

  static Future stopSpeech() async {
    flutterTts.stop();
  }

  static Future pauseSpeech() async {
    flutterTts.pause();
  }
}
