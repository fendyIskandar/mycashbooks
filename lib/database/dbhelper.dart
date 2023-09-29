// ignore_for_file: avoid_print

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

import '../model/cashflow.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cashbook.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cashflow(id INTEGER PRIMARY KEY, tanggal STRING, nominal INTEGER, keterangan TEXT, tipe STRING)',
    );

    await db.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, username STRING, password STRING)',
    );

    await db.rawInsert(
      "INSERT INTO user (name, username, password) VALUES ('Fendy Iskandar', 'fendy', 'password')",
    );
    print('DB Created');
  }

  Future<dynamic> getLogin(String username, String password) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery(
      "SELECT * FROM user WHERE username = '$username' AND password = '$password'",
    );
    return res;
  }

  Future<String> getPassword() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery(
      "SELECT password FROM user WHERE username = 'fendy'",
    );
    String password = list[0]['password'].toString();
    return password;
  }

  Future<bool> updatePassword(String password) async {
    var dbClient = await db;
    int res = await dbClient!.rawUpdate(
      "UPDATE user SET password = '$password' WHERE username = 'fendy'",
    );
    return res > 0 ? true : false;
  }

  Future<int> saveCashflow(Cashflow cashflow) async {
    var dbClient = await db;
    int res = await dbClient!.insert('cashflow', cashflow.toMap());
    print('Cashflow saved');
    return res;
  }

  Future<List<Cashflow>> getCashflow() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery("SELECT * FROM cashflow");
    List<Cashflow> cashflowList = [];
    for (int i = 0; i < list.length; i++) {
      var cashflow = Cashflow(
        list[i]['tanggal'],
        list[i]['nominal'],
        list[i]['keterangan'],
        list[i]['tipe'],
      );
      cashflow.setCashflowId(list[i]['id']);
      cashflowList.add(cashflow);
    }
    print(cashflowList);
    return cashflowList;
  }

  Future<int> getTotalNominalByType(String type) async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery(
        "SELECT SUM(nominal) as total_nominal FROM cashflow WHERE tipe = '$type'");

    if (list.isNotEmpty && list[0]['total_nominal'] != null) {
      int totalNominal = int.parse(list[0]['total_nominal'].toString());
      return totalNominal;
    } else {
      return 0;
    }
  }

  Future<bool> updateCashflow(Cashflow cashflow) async {
    var dbClient = await db;
    int res = await dbClient!.update(
      'cashflow',
      cashflow.toMap(),
      where: 'id=?',
      whereArgs: <int>[cashflow.id],
    );
    return res > 0 ? true : false;
  }

  Future<int> deleteCashflow(Cashflow cashflow) async {
    var dbClient = await db;
    int res = await dbClient!.rawDelete(
      'DELETE FROM cashflow WHERE id= ?',
      [cashflow.id],
    );
    return res;
  }
}
