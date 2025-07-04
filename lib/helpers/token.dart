import 'package:shared_preferences/shared_preferences.dart';

class GetToken {
  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }
}
