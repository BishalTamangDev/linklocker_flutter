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
            .then((_) => true)
            .catchError((_) => false);

        // create link table
        bool linkTblResponse = await dbPath
            .execute(
                "CREATE TABLE $linkTblName (link_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, email TEXT, date_of_birth TEXT, note TEXT)")
            .then((_) => true)
            .catchError((_) => false);

        // create contact table
        bool contactTblResponse = await dbPath
            .execute(
                "CREATE TABLE $contactTblName (contact_id INTEGER PRIMARY KEY AUTOINCREMENT, link_id INTEGER, contact TEXT, country TEXT)")
            .then((_) => true)
            .catchError((_) => false);

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
    bool userTableResponse = await resetUserTable();
    bool linkTableResponse = await resetLinkTable();
    bool contactTableResponse = await resetContactTable();

    developer.log(userTableResponse
        ? "user table reset successfully"
        : "user rest failed");
    developer.log(linkTableResponse
        ? "link table reset successfully"
        : "link rest failed");
    developer.log(contactTableResponse
        ? "contact table reset successfully"
        : "contact rest failed");
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
        .then((_) => "success")
        .catchError((error) => error);

    return response;
  }

//   reset user table
  Future<bool> resetUserTable() async {
    Database tempDb = await getDb();

    bool reset = await tempDb
        .delete(userTblName)
        .then((_) => true)
        .catchError((_) => false);

    developer.log(
        reset ? "User table reset successfully!" : "Couldn't reset user table");

    return reset;
  }

//   links
// insert link
  Future<int> insertLink(Map<String, dynamic> data) async {
    Database tempDb = await getDb();
    return await tempDb.insert(linkTblName, data);
  }

// update link
  Future<String> updateLink(int linkId, dynamic data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .update(
          linkTblName,
          data,
          where: "link_id = ?",
          whereArgs: [linkId],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // get all links
  Future<List<Map<String, dynamic>>> getLinks() async {
    // await Future.delayed(const Duration(seconds: 3));

    Database tempDb = await getDb();

    List<Map<String, dynamic>> data = await tempDb.query(linkTblName);

    // convert data into mutable data
    List<Map<String, dynamic>> mutableData = data
        .map(
          (datum) => {...datum},
        )
        .toList();

    // fetch contacts for each link
    for (var datum in mutableData) {
      datum['contacts'] = await getContacts(datum['link_id']);
    }

    return mutableData;
  }

// get link
  Future<Map<String, dynamic>> getLink(int linkId) async {
    Database tempDb = await getDb();

    Map<String, dynamic> data = {};

    List<dynamic> links = await tempDb.query(
      linkTblName,
      where: "link_id = ?",
      whereArgs: [linkId],
    );

    for (var link in links) {
      data = link;
    }

    return data;
  }

// delete link
  Future<String> deleteLink(int linkId) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          linkTblName,
          where: "link_id = ?",
          whereArgs: [linkId],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // search link
  Future<List<Map<String, dynamic>>> searchLink({required String title}) async {
    List<Map<String, dynamic>> data = [];
    List<Map<String, dynamic>> finalData = [];

    if (title == "") {
      return [];
    }

    var tempDb = await getDb();

    data = await tempDb.query(
      linkTblName,
      where: "name LIKE ?",
      whereArgs: ["%$title%"],
    );

    // convert data into mutable data
    List<Map<String, dynamic>> mutableData =
        data.map((datum) => {...datum}).toList();

    for (var datum in mutableData) {
      // fetch contacts
      datum['contacts'] = await getContacts(datum['link_id']);
      finalData.add(datum);
    }

    return finalData;
  }

  //   reset link table
  Future<bool> resetLinkTable() async {
    Database tempDb = await getDb();

    bool reset = await tempDb
        .delete(linkTblName)
        .then((_) => true)
        .catchError((_) => false);

    developer.log(
        reset ? "Link table reset successfully!" : "Couldn't reset link table");

    return reset;
  }

// contacts
// insert contact
  Future<int> insertContact(int linkId, Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    data['link_id'] = linkId;

    developer.log("Contact data :: $data");

    int id = await tempDb
        .insert(contactTblName, data)
        .then((id) => id)
        .catchError((_) => 0);

    return id;
  }

  // get all contacts :: temporary
  Future<List<Map<String, dynamic>>> getAllContacts() async {
    Database tempDb = await getDb();

    List<Map<String, dynamic>> data = await tempDb.query(contactTblName);

    return data;
  }

  // get contacts
  Future<List<Map<String, dynamic>>> getContacts(int linkId) async {
    Database tempDb = await getDb();

    List<Map<String, dynamic>> data = [];

    data = await tempDb.query(
      contactTblName,
      where: "link_id = ?",
      whereArgs: [linkId],
    );

    return data;
  }

  // get contact
  Future<Map<String, dynamic>> getContact(int contactId) async {
    Map<String, dynamic> data = {};

    Database tempDb = await getDb();

    List<Map<String, dynamic>> contacts = await tempDb.query(
      contactTblName,
      where: "contact_id = ?",
      whereArgs: [contactId],
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
  Future<String> deleteContact(int contactId) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          contactTblName,
          where: "contact_id = ?",
          whereArgs: [contactId],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // delete contacts by link
  Future<String> deleteContacts(int linkId) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .delete(
          contactTblName,
          where: "link_id = ?",
          whereArgs: [linkId],
        )
        .then((onValue) => "success")
        .catchError((error) => error);

    return response;
  }

  // search contacts
  Future<List<Map<String, dynamic>>> searchContact(String contact) async {
    Database tempDb = await getDb();
    List<Map<String, dynamic>> finalData = [];
    // get contacts
    List<Map<String, dynamic>> contacts = await tempDb.query(
      contactTblName,
      where: "contact LIKE ?",
      whereArgs: ["%$contact%"],
    );

    // get link details
    for (var contact in contacts) {
      var link = await getLink(contact['link_id']);

      Map<String, dynamic> mutableLink = {};
      mutableLink.addAll(link);

      List<Map<String, dynamic>> contactIntoList = [];
      contactIntoList.add(contact);

      mutableLink['contacts'] = contactIntoList;

      finalData.add(mutableLink);
    }

    return finalData;
  }

  //   reset contact table
  Future<bool> resetContactTable() async {
    Database tempDb = await getDb();

    bool reset = await tempDb
        .delete(contactTblName)
        .then((_) => true)
        .catchError((_) => false);

    developer.log(reset
        ? "Contact table reset successfully!"
        : "Couldn't reset contact table");

    return reset;
  }
}
