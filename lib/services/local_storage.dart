import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('is_first_launch') ?? true;
    if (isFirst) {
      await prefs.setBool('is_first_launch', false);
    }
    return isFirst;
  }
}
