import 'dart:developer' as developer;
import 'dart:io';

import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/models/user_model.dart';
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
  final String userContactTblName = "user_contact_tbl";
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
                "CREATE TABLE $userTblName (user_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, profile_picture BLOB)")
            .then((_) => true)
            .catchError((_) => false);

        // create user contact table
        bool userContactTblResponse = await dbPath
            .execute(
                "CREATE TABLE $userContactTblName (user_contact_id INTEGER PRIMARY KEY AUTOINCREMENT, country TEXT, contact TEXT)")
            .then((_) => true)
            .catchError((_) => false);

        // create link table
        bool linkTblResponse = await dbPath
            .execute(
                "CREATE TABLE $linkTblName (link_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, email TEXT, date_of_birth TEXT, note TEXT, profile_picture BLOB)")
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
            : "Unable to create user table");
        developer.log(userContactTblResponse
            ? "User contact table created,"
            : "Unable to create user contact table.");
        developer.log(linkTblResponse
            ? "Link table created"
            : "Unable to create link table");
        developer.log(contactTblResponse
            ? "Contact table created"
            : "Unable to create contact table");

        if (!userTblResponse ||
            !userContactTblResponse ||
            !linkTblResponse ||
            !contactTblResponse) {
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
    bool userContactTableResponse = await resetUserContactTable();
    bool linkTableResponse = await resetLinkTable();
    bool contactTableResponse = await resetContactTable();

    developer.log(userTableResponse
        ? "user table reset successfully."
        : "Unable to reset user table.");
    developer.log(userContactTableResponse
        ? "user contact table reset successfully"
        : "Unable to reset user contact table.");
    developer.log(linkTableResponse
        ? "link table reset successfully"
        : "Unable to reset link table.");
    developer.log(contactTableResponse
        ? "contact table reset successfully"
        : "Unable to reset contact table.");
  }

//   user table
//   get user
  Future<Map<String, dynamic>> getUser() async {
    Map<String, dynamic> data = {};

    Database tempDb = await getDb();

    // fetch users
    List<Map<String, dynamic>> users = await tempDb.query(userTblName);
    var mutableUsers = users.map((user) => {...user}).toList();

    // fetch user contacts
    List<Map<String, dynamic>> contacts = await fetchUserContacts();
    var mutableContacts = contacts.map((contact) => {...contact}).toList();

    // get last user
    for (var user in mutableUsers) {
      data = user;
    }

    data['contacts'] = mutableContacts;

    developer.log(
        "User details -> id :: ${data['user_id']}, name :: ${data['name']}, email :: ${data['email']} ");
    developer.log("User contacts :: ${data['contacts']}");

    // developer.log(data['profile_picture'] == null
    //     ? "Profile Picture :: No"
    //     : "Profile Picture :: Yes");

    return data;
  }

  // insert user
  Future<String> insertUser(UserModel userModel) async {
    Database tempDb = await getDb();

    // decode data
    var data = {
      'name': userModel.getName,
      'email': userModel.getEmail,
      'profile_picture': userModel.getProfilePicture,
    };

    await tempDb.delete(userTblName);

    String response = await tempDb
        .insert(userTblName, data)
        .then((onValue) => "success")
        .catchError((error) => error.toString());

    return response;
  }

  // update user
  Future<String> updateUser(UserModel userModel) async {
    Database tempDb = await getDb();

    // decode data
    var data = {
      'name': userModel.getName,
      'email': userModel.getEmail,
      'profile_picture': userModel.getProfilePicture,
    };

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

//   user contact
//   insert user contact
  Future<String> insertUserContact(Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .insert(userContactTblName, data)
        .then((_) => "success")
        .catchError((e) => e.toString());

    return response;
  }

//   update user contact
  Future<String> updateUserContact(
      int userContactId, Map<String, dynamic> data) async {
    Database tempDb = await getDb();

    String response = await tempDb
        .update(
          userContactTblName,
          data,
          where: "user_contact_id = ?",
          whereArgs: [userContactId],
        )
        .then((_) => "success")
        .catchError((e) => e.toString());

    return response;
  }

//   fetch user contacts
  Future<List<Map<String, dynamic>>> fetchUserContacts() async {
    Database tempDb = await getDb();

    List<Map<String, dynamic>> contacts =
        await tempDb.query(userContactTblName);

    return contacts;
  }

//   reset user contact table
  Future<bool> resetUserContactTable() async {
    Database tempDb = await getDb();

    bool reset = await tempDb
        .delete(userContactTblName)
        .then((_) => true)
        .catchError((_) => false);

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

//   get categorized links
  Future<List<Map<String, dynamic>>> getCategorizedLinks() async {
    Database tempDb = await getDb();

    // get all links
    var links = await getLinks();

    List<Map<String, dynamic>> finalData = [];

    for (var category in AppConstants.categoryList) {
      int count = 0;
      for (var link in links) {
        if (category == link['category']) {
          count++;
        }
      }

      finalData.add(
        {
          'category': category,
          'count': count,
        },
      );
    }

    return finalData;
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
