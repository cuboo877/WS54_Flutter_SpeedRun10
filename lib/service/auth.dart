import 'package:ws54_flutter_speedrun10/service/shared_pref.dart';
import 'package:ws54_flutter_speedrun10/service/sql_service.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDAO.getUserDataByAccountAndPassword(account, password);
      await SharedPref.setLoggedUserID(userData.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasAcocuntBeenRegister(String account) async {
    try {
      UserData userData = await UserDAO.getUserDataByAccount(account);
      await SharedPref.setLoggedUserID(userData.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAtuh(UserData userData) async {
    await UserDAO.addUser(userData);
    await SharedPref.setLoggedUserID(userData.id);
  }

  static Future<void> logOut() async {
    await SharedPref.removeUserID();
  }
}
