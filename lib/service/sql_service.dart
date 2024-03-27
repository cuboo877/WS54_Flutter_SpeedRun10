import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sql {
  static Database? database;

  static Future<Database> _initDataBase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws.db"),
        onCreate: (db, version) async {
      await db.execute(
          "create table users (id text primary key, username text, account text, password text, birthday text)");
      await db.execute(
          "create table passwords (id text primary key, userID text, tag text, url text, login text, password text, isFav integer, foreign key (userID) references users (id))");
    }, version: 1);
    return database!;
  }

  static Future<Database> getDBConncet() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDataBase();
    }
  }
}

class UserDAO {
  static Future<UserData> getUserDataByUserID(String userID) async {
    final Database database = await Sql.getDBConncet();
    final maps =
        await database.query("users", where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> result = maps.first;

    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccount(String account) async {
    final Database database = await Sql.getDBConncet();
    final maps = await database
        .query("users", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> result = maps.first;

    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String account, String password) async {
    final Database database = await Sql.getDBConncet();
    final maps = await database.query("users",
        where: "account = ? AND password = ?", whereArgs: [account, password]);
    Map<String, dynamic> result = maps.first;

    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<void> addUser(UserData data) async {
    final Database database = await Sql.getDBConncet();
    await database.insert("users", data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUser(UserData data) async {
    final Database database = await Sql.getDBConncet();
    await database.update("users", data.toJson(),
        where: "id = ?",
        whereArgs: [data.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class PasswordDAO {
  static Future<List<PasswordData>> getPasswordListByUserID(
      String userID) async {
    final Database database = await Sql.getDBConncet();
    List<Map<String, dynamic>> result = await database
        .query("passwords", where: "userID = ?", whereArgs: [userID]);
    return List.generate(result.length, (index) {
      return PasswordData(
          result[index]["id"],
          result[index]["userID"],
          result[index]["tag"],
          result[index]["url"],
          result[index]["login"],
          result[index]["password"],
          result[index]["isFav"]);
    });
  }

  static Future<List<PasswordData>> getPasswordListByCondition(
      String userID,
      String tag,
      String url,
      String login,
      String password,
      String id,
      bool hasFav,
      int isFav) async {
    final Database database = await Sql.getDBConncet();

    String whereCondition = "userID = ?";
    List whereArgs = [userID];

    if (tag.trim().isNotEmpty) {
      whereCondition += "AND tag LIKE ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isNotEmpty) {
      whereCondition += "AND url LIKE ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isNotEmpty) {
      whereCondition += "AND login LIKE ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isNotEmpty) {
      whereCondition += "AND password LIKE ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isNotEmpty) {
      whereCondition += "AND id LIKE ?";
      whereArgs.add("%$id%");
    }

    if (hasFav) {
      whereCondition += "AND isFav = ?";
      whereArgs.add(isFav);
    }

    List<Map<String, dynamic>> result = await database.query("passwords",
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(result.length, (index) {
      return PasswordData(
          result[index]["id"],
          result[index]["userID"],
          result[index]["tag"],
          result[index]["url"],
          result[index]["login"],
          result[index]["password"],
          result[index]["isFav"]);
    });
  }

  static Future<void> addPassword(PasswordData passwordData) async {
    final Database database = await Sql.getDBConncet();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removePassword(String passwordID) async {
    final Database database = await Sql.getDBConncet();
    await database
        .delete("passwords", where: "id = ?", whereArgs: [passwordID]);
  }

  static Future<void> updatePassword(PasswordData passwordData) async {
    final Database database = await Sql.getDBConncet();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class UserData {
  final String account;
  late String birthday;
  late String id;
  late String password;
  late String username;

  UserData(this.id, this.username, this.account, this.password, this.birthday);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "account": account,
      "password": password,
      "birthday": birthday
    };
  }
}

class PasswordData {
  final String id;
  late int isFav;
  late String login;
  late String password;
  late String tag;
  late String url;
  late String userID;

  PasswordData(this.id, this.userID, this.tag, this.url, this.login,
      this.password, this.isFav);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userID": userID,
      "tag": tag,
      "url": url,
      "login": login,
      "password": password,
      "isFav": isFav
    };
  }
}
