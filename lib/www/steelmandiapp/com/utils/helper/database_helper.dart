import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/authModel/auth_user.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/product_bar_helper.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

class DatabaseHelper with ProductBarHelper {
  static DatabaseHelper instance;
  static final _databaseName = "${CoreSettings.appName}.db";
  int _databaseVersion = 1;
  static Database _database;

  DatabaseHelper._privateConstructor();

  DatabaseHelper() {
    instance == null
        ? instance = DatabaseHelper._privateConstructor()
        : instance;
  }

  Future<int> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return int.parse(packageInfo.buildNumber);
  }

  Future<Database> get database async {
    if (_database != null) {
      print("Existing Database Instance");
      return _database;
    }
    // lazily instantiate the db the first time it is accessed
    print("New Database Instance");
    _database = await _initDatabase();
    return _database;
  }

  Future<bool> shouldDeleteDatabase(String path) async {
    Database db;
    bool willDatabaseDelete = false;
    try {
      db = await openDatabase(path);
      int buildNumber = await getBuildNumber();
      int version = await db.getVersion();
      // Set Current Database Version to Existing Db version
      _databaseVersion = version;
      print("App Build Number: $buildNumber");
      print("Existing Database Version Number: $version");
      if (version != null && version != buildNumber) {
        willDatabaseDelete = true;
        _databaseVersion = buildNumber;
      } else {
        print(
            "Working On Existing Database with Version: $version and Build: $buildNumber");
      }
    } catch (_) {} finally {
      await db?.close();
    }
    return willDatabaseDelete;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // For checking Version
    if (await shouldDeleteDatabase(path)) {
      await deleteDatabase(path);
      print("Existing Database Deleted");
    }

    return await openDatabase(path,
        onCreate: _onCreate, version: _databaseVersion);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${UserTableHelper.tableName} (
            ${UserTableHelper.userId} INTEGER,
            ${UserTableHelper.userName} TEXT,
            ${UserTableHelper.userRole} TEXT ,
            ${UserTableHelper.userEmail} TEXT,
            ${UserTableHelper.userMobile} TEXT,
            ${UserTableHelper.newUser} INTEGER,
            ${UserTableHelper.responseStatus} TEXT,
            ${UserTableHelper.responseMessage} TEXT,
             ${UserTableHelper.photoURL} TEXT,
             ${UserTableHelper.tin} TEXT,
             ${UserTableHelper.address} TEXT,
             ${UserTableHelper.pin} TEXT,
             ${UserTableHelper.country} TEXT,
             ${UserTableHelper.state} TEXT,
             ${UserTableHelper.city} TEXT,
             ${UserTableHelper.citizenship} TEXT,
             ${UserTableHelper.dob} TEXT,
             ${UserTableHelper.gender} TEXT,
              ${UserTableHelper.firstName} TEXT,
              ${UserTableHelper.middleName} TEXT,
             ${UserTableHelper.lastName} TEXT         
          )
          ''');
    // Create Table For Product
    await db.execute('''
          CREATE TABLE ${ProductBarTableHelper.tableName} (
            ${ProductBarTableHelper.productIdCol} INTEGER NOT NULL,
            ${ProductBarTableHelper.productSpecNameCol} TEXT NOT NULL,
            ${ProductBarTableHelper.productSpecDisplayNameCol} TEXT NOT NULL,
            ${ProductBarTableHelper.productSpecSelectedCol} INTEGER NOT NULL,
            ${ProductBarTableHelper.productSpecMarketCol} TEXT NOT NULL,
            ${ProductBarTableHelper.productSpecIconCol} TEXT NOT NULL,
            ${ProductBarTableHelper.productSpecIdCol} INTEGER NOT NULL ,           
            ${ProductBarTableHelper.productSpecGeneratedIdCol} TEXT NOT NULL          


          )
          ''');
  }

  Future<int> insert(AuthUser model) async {
    Database db = await instance.database;
    return await db.insert(UserTableHelper.tableName, model.toJsonSqlFlite());
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(UserTableHelper.tableName);
  }

  Future<AuthUser> getUser() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> data =
        await db.query(UserTableHelper.tableName);
    //print("Data In Helper: $data");
    return data.length == 0 ? null : AuthUser.fromJsonSqlflite(data.first);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${UserTableHelper.tableName}'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[UserTableHelper.userId];
    return await db.update(UserTableHelper.tableName, row,
        where: '${UserTableHelper.userId} = ?', whereArgs: [id]);
  }

  Future<int> updateNewUser(AuthUser user) async {
    Database db = await instance.database;
    //print(user.user.mobileNo);
    int id = user.user.userId;
    return await db.update(UserTableHelper.tableName, user.toJsonSqlFlite(),
        where: '${UserTableHelper.userId} = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    int result = await db.delete(UserTableHelper.tableName,
        where: '${UserTableHelper.userId} = ?', whereArgs: [id]);
    return result;
  }

  /// Remove All records
  Future<int> removeAllUser() async {
    Database db = await instance.database;
    int result = await db.delete(UserTableHelper.tableName);
    return result;
  }

  // Product
  Future<int> insertProduct_(UserProduct b) async {
    Database db = await instance.database;
    return await insertProduct(b, db);
  }

  // Update A Product
  Future<int> updateProduct_(UserProduct b) async {
    Database db = await instance.database;
    return await updateProduct(b, db);
  }

  Future<List<UserProduct>> getAllProduct() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> productMapList = await getAllProducts(db);
    //print("Retrive List From DATABASE: $productMapList");
    List<UserProduct> uList = productMapList
        .map((Map<String, dynamic> json) => UserProduct.fromLocal(json))
        .toList();
    return uList;
  }

  Future<int> deleteCurrentProduct(String id) async {
    Database db = await instance.database;
    return await deleteProduct(id, db);
  }

  Future<int> removeAllProduct() async {
    Database db = await instance.database;
    return await dropProductTable(db);
  }
}
