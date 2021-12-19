import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  static String emailValue = "";

//  static Future<SharedPreferences> _instance;
//  static Future<SharedPreferences> get getInstance =>
//      _instance == null ? SharedPreferences.getInstance() : _instance;

  static Future<bool> getLoggedOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove("AuthenticationToken");
  }

  static Future<bool> savePreferValue(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool result = await prefs.setBool("preference", value);
    return result;
  }

  static Future<bool> getPreferValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isPrefer = prefs.getBool("preference");
    isPrefer = isPrefer == null ? false : isPrefer;
    return isPrefer;
  }

  static Future<bool> saveAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool result = await prefs.setString("AuthenticationToken", token);
    return result;
  }

  static Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("AuthenticationToken");
    return token;
  }

  static Future<bool> saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userEmail", email);
    emailValue = await getEmail();
    //print(emailValue);
    if (emailValue != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString("userEmail");
    //print(prefs.getString("userEmail"));
    if (email != null) {
      return email;
    }
    return '';
  }

  static Future<void> saveSkipInfo(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('skip', value);
    //print(prefs.getBool("skip"));
  }

  static Future<bool> getSkipInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool v = prefs.getBool('skip');
    return v == null ? false : v;
  }

  static Future<bool> saveLastActiveProductId(String productId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('lastActiveProductId', productId);
  }

  static Future<String> getLastActiveProductId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastActiveProductId');
  }

  static Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
