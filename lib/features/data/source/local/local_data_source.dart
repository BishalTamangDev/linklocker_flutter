import 'dart:developer' as developer;
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSource {
  // private constructor
  LocalDataSource._();

  // database
  Database? _db;

  // singleton
  static LocalDataSource getInstance() => LocalDataSource._();

  // database
  final String dbName = "linklocker_db.db";

  // table
  final String userTblName = "user_tbl";
  final String linkTblName = "link_tbl";
  final String contactTblName = "contact_tbl";

// open database & create table
  Future<Database?> openDb() async {
    int version = 1;

    // app data path
    Directory appDocumentDir = await getApplicationDocumentsDirectory();

    // database path
    String dbPath = join(appDocumentDir.path, dbName);

    return await openDatabase(
      dbPath,
      version: version,
      onCreate: (dbPath, version) async {
        // create user table
        bool userTblResponse = await dbPath
            .execute(
                "CREATE TABLE $userTblName (user_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, email TEXT)")
            .then((onValue) => true)
            .catchError((error) => false);

        // create link table
        bool linkTblResponse = await dbPath
            .execute(
                "CREATE TABLE $linkTblName (link_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, email TEXT, date_of_birth TEXT, note TEXT)")
            .then((onValue) => true)
            .catchError((error) => false);

        // create contact table
        bool contactTblResponse = await dbPath
            .execute(
                "CREATE TABLE $contactTblName (contact_id INTEGER PRIMARY KEY AUTOINCREMENT, link_id INTEGER, contact TEXT, country TEXT)")
            .then((onValue) => true)
            .catchError((error) => false);

        // debugging
        developer.log(userTblResponse
            ? "User table created"
            : "Error in creating user table");
        developer.log(linkTblResponse
            ? "Link table created"
            : "Error in creating link table");
        developer.log(contactTblResponse
            ? "Contact table created"
            : "Error in creating contact table");

        if (!userTblResponse || !linkTblResponse || !contactTblResponse) {
          //   delete database
          developer.log(
              "Error occurred in initiating database. Some table couldn't be created.");
        }
      },
    );
  }

// get database
  Future<Database> getDb() async {
    _db ??= await openDb();
    return _db!;
  }

//   reset database
  Future<void> resetDb() async {
    Database? tempDb = await getDb();

    int rowAffected1 = await tempDb.delete(userTblName);
    int rowAffected2 = await tempDb.delete(linkTblName);
    int rowAffected3 = await tempDb.delete(contactTblName);

    bool response1 = rowAffected1 > 0 ? true : false;
    bool response2 = rowAffected2 > 0 ? true : false;
    bool response3 = rowAffected3 > 0 ? true : false;

    developer
        .log(response1 ? "user table reset successfully" : "user rest failed");
    developer
        .log(response2 ? "link table reset successfully" : "link rest failed");
    developer.log(
        response3 ? "contact table reset successfully" : "contact rest failed");
  }

//   user table
//   get user
  Future<Map<String, dynamic>> getUser() async {
    Map<String, dynamic> data = {};

    Database tempDb = await getDb();

    var users = await tempDb.query(userTblName);

    developer.log("Users: $users");

    for (var user in users) {
      data = user;
    }

    return data;
  }

  // insert user
  Future<String> insertUser(Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    await tempDb.delete(userTblName);

    String response = await tempDb
        .insert(userTblName, data)
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // update user
  Future<String> updateUser(Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .update(userTblName, data)
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

//   delete user
  Future<String> deleteUser() async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(userTblName)
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

//   links
// insert link
  Future<String> insertLink(Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .insert(linkTblName, data)
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

// update link
  Future<String> updateLink(int link_id, dynamic data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .update(
          linkTblName,
          data,
          where: "link_id = ?",
          whereArgs: [link_id],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

// get all links
  Future<List<Map<String, dynamic>>> getLinks() async {
    Database tempDb = await getDb();

    List<Map<String, dynamic>> data = [];

    data = await tempDb.query(linkTblName);

    return data;
  }

// get link
  Future<Map<String, dynamic>> getLink(int link_id) async {
    Database tempDb = await getDb();

    Map<String, dynamic> data = {};

    List<dynamic> links = await tempDb.query(
      linkTblName,
      where: "link_id = ?",
      whereArgs: [link_id],
    );

    for (var link in links) {
      data = link;
    }

    return data;
  }

// delete link
  Future<String> deleteLink(int id) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          linkTblName,
          where: "link_id = ?",
          whereArgs: [id],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

// contacts
// insert contact
  Future<String> insertContact(dynamic data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .insert(contactTblName, data)
        .then((onValue) => "success")
        .catchError(
          (error) => error,
        );

    return response;
  }

  // get contacts
  Future<List<Map<String, dynamic>>> getContacts(int link_id) async {
    Database tempDb = await getDb();

    List<Map<String, dynamic>> data = await tempDb.query(contactTblName);

    return data;
  }

  // get contact
  Future<Map<String, dynamic>> getContact(int contact_id) async {
    Map<String, dynamic> data = {};

    Database tempDb = await getDb();

    List<Map<String, dynamic>> contacts = await tempDb.query(
      contactTblName,
      where: "contact_id = ?",
      whereArgs: [contact_id],
    );

    for (var contact in contacts) {
      data = contact;
    }

    return data;
  }

  // update contact
  Future<String> updateContact(int id, dynamic data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .update(contactTblName, data)
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // delete contact
  Future<String> deleteContact(int contact_id) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          contactTblName,
          where: "contact_id = ?",
          whereArgs: [contact_id],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // delete contacts by link
  Future<String> deleteContacts(int link_id) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          contactTblName,
          where: "link_id = ?",
          whereArgs: [link_id],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }
}
