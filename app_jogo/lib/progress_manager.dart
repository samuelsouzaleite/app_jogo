import 'package:shared_preferences/shared_preferences.dart';

class ProgressManager {
  static Future<void> saveProgress(int level, int wordsGuessedCorrectly) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('level_$level', wordsGuessedCorrectly);
  }

  static Future<int> loadProgress(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level_$level') ?? 0;
  }
}
