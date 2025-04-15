import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/link/data/models/contact_model.dart';
import 'package:linklocker/features/link/data/models/link_model.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';
import 'package:linklocker/features/metric/data/models/metric_model.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../features/profile/data/models/profile_contact_model.dart';
import '../../../../features/profile/data/models/profile_model.dart';

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
  static final String profileTbl = "profile_tbl";
  static final String profileContactTbl = "profile_contact_tbl";
  static final String linkTbl = "link_tbl";
  static final String contactTbl = "contact_tbl";

  // open database & create table
  Future<Database?> _initializeDatabase() async {
    int version = 1;

    // app data path
    Directory appDocumentDir = await getApplicationDocumentsDirectory();

    // database path
    String dbPath = join(appDocumentDir.path, dbName);

    return await openDatabase(
      dbPath,
      version: version,
      onCreate: (dbPath, version) async {
        // create profile table
        String query = '''
          CREATE TABLE IF NOT EXISTS $profileTbl (
            profile_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email_address TEXT,
            profile_picture BLOB
          )
        ''';

        bool profileTblResponse = await dbPath
            .rawQuery(query)
            .then((_) => true)
            .catchError((_) => false);

        // create profile contact table
        query = '''
          CREATE TABLE IF NOT EXISTS $profileContactTbl (
            contact_id INTEGER PRIMARY KEY AUTOINCREMENT,
            profile_id INTEGER,
            country TEXT,
            number TEXT,
            FOREIGN KEY (profile_id) REFERENCES $profileTbl(profile_id) ON DELETE CASCADE
          )
        ''';
        bool profileContactTblResponse = await dbPath
            .rawQuery(query)
            .then((_) => true)
            .catchError((_) => false);

        // create link table
        query = '''
          CREATE TABLE IF NOT EXISTS $linkTbl (
            link_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            category TEXT,
            email_address TEXT,
            date_of_birth TEXT,
            note TEXT,
            profile_picture BLOB
          )
        ''';
        bool linkTblResponse = await dbPath
            .rawQuery(query)
            .then((_) => true)
            .catchError((_) => false);

        // create contact table
        query = '''
          CREATE TABLE IF NOT EXISTS $contactTbl (
            contact_id INTEGER PRIMARY KEY AUTOINCREMENT,
            link_id INTEGER,
            number TEXT,
            country TEXT,
            FOREIGN KEY (link_id) REFERENCES $linkTbl (link_id) ON DELETE CASCADE
          )
        ''';
        bool contactTblResponse = await dbPath
            .rawQuery(query)
            .then((_) => true)
            .catchError((_) => false);

        // debugging
        debugPrint("Profile Table Created :: $profileTblResponse");
        debugPrint(
            "Profile Contact Table Created :: $profileContactTblResponse");
        debugPrint("Link Table Created :: $linkTblResponse");
        debugPrint("Link Contact Table Created :: $contactTblResponse");

        if (!profileTblResponse ||
            !profileContactTblResponse ||
            !linkTblResponse ||
            !contactTblResponse) {
          debugPrint(
              "Error occurred in initiating database. Some table couldn't be created.");
        }
      },
    );
  }

  // get database
  Future<Database> getDatabase() async {
    _db ??= await _initializeDatabase();
    return _db!;
  }

  // reset everything
  Future<void> resetDatabase() async {
    await resetProfile();
    await resetProfileContact();
    await resetLink();
    await resetContact();
  }

  // profile related
  // add profile
  Future<bool> addProfile(
      ProfileEntity profileEntity, List<ProfileContactEntity> contacts) async {
    try {
      Database db = await getDatabase();

      // create profile model from entity
      final ProfileModel profileModel = ProfileModel.fromEntity(profileEntity);
      final Map<String, dynamic> profileDataToUpload =
          profileModel.profileDataToUpload;

      await db.transaction((txn) async {
        int profileId = await txn.insert(profileTbl, profileDataToUpload);

        if (profileId <= 0) {
          throw Exception(
              "Couldn't add profile with ID :: ${profileEntity.id}");
        }

        for (var contact in contacts) {
          final ProfileContactModel contactModel =
              ProfileContactModel.fromEntity(contact);
          Map<String, dynamic> contactDataToUpload =
              contactModel.dataToUpload(profileId);

          int contactId =
              await txn.insert(profileContactTbl, contactDataToUpload);

          if (contactId <= 0) {
            throw Exception("Couldn't add contact with ID :: $contactId");
          }
        }
      });
      return true;
    } catch (e, stackTrace) {
      debugPrint("Error adding profile : $e\n$stackTrace");
      return false;
    }
  }

  // update profile
  Future<bool> updateProfile(
      ProfileEntity profileEntity, List<ProfileContactEntity> contacts) async {
    try {
      Database db = await getDatabase();

      // create profile model from entity
      final ProfileModel profileModel = ProfileModel.fromEntity(profileEntity);
      final Map<String, dynamic> profileDataToUpload =
          profileModel.profileDataToUpload;

      await db.transaction((txn) async {
        // update profile
        int profileRowsAffected = await txn.update(
          profileTbl,
          profileDataToUpload,
          where: "profile_id = ?",
          whereArgs: [profileEntity.id],
        );

        if (profileRowsAffected == 0) {
          throw Exception('Profile not found or not changes made.');
        }

        // update contact
        for (var contact in contacts) {
          final ProfileContactModel contactModel =
              ProfileContactModel.fromEntity(contact);
          final Map<String, dynamic> contactDataToUpload =
              contactModel.dataToUpload(profileEntity.id!);

          int contactRowsAffected = await txn.update(
            profileContactTbl,
            contactDataToUpload,
            where: "contact_id = ?",
            whereArgs: [contactModel.contactId],
          );

          if (contactRowsAffected == 0) {
            throw Exception(
                'Contact not found or no changes made for contact ${contactModel.contactId}.');
          }
        }
      });
      return true;
    } catch (e, stackTrace) {
      debugPrint("Error in updating profile : $e\n$stackTrace");
      return false;
    }
  }

  // fetch profile
  Future<Either<bool, List<Map<String, dynamic>>>> fetchProfile() async {
    try {
      Database db = await getDatabase();

      final String sql = '''
        SELECT * FROM $profileTbl AS a
        INNER JOIN $profileContactTbl AS b
        ON a.profile_id = b.profile_id
      ''';

      final profiles = await db.rawQuery(sql);

      if (profiles.isEmpty) {
        return Left(false);
      } else {
        return Right(profiles);
      }
    } catch (e, stackTrace) {
      debugPrint("Error in fetching profile :: $e\n$stackTrace");
      return Left(false);
    }
  }

  // delete profile
  Future<bool> deleteProfile() async {
    try {
      Database db = await getDatabase();
      final int rowsAffected = await db.delete(profileTbl);
      return rowsAffected >= 0 ? true : false;
    } catch (e, stackTrace) {
      debugPrint("Error deleting profile: $e\n$stackTrace");
      return false;
    }
  }

  // reset profile table
  Future<bool> resetProfile() async {
    try {
      Database db = await getDatabase();
      int rowsAffected = await db.delete(profileTbl);
      return rowsAffected >= 0;
    } catch (e, stackTrace) {
      debugPrint("Error resetting profile table: $e\n$stackTrace");
      return false;
    }
  }

  // reset profile contact table
  Future<bool> resetProfileContact() async {
    try {
      Database db = await getDatabase();
      int rowsAffected = await db.delete(profileContactTbl);
      return rowsAffected >= 0;
    } catch (e, stackTrace) {
      debugPrint("Error resetting profile contact table :: $e\n$stackTrace");
      return false;
    }
  }

  // link related
  // add link
  Future<bool> addLink(
      LinkEntity linkEntity, List<ContactEntity> contacts) async {
    try {
      Database db = await getDatabase();

      await db.transaction((txn) async {
        final data =
            LinkModel.fromEntity(linkEntity).toMap(uploadingData: true);

        // insert link
        int linkId = await txn.insert(linkTbl, data);

        if (linkId <= 0) {
          throw Exception("Couldn't add profile");
        }

        // insert contacts
        for (var contact in contacts) {
          Map<String, dynamic> data =
              ContactModel.fromEntity(contact).toMap(uploadingData: true);
          data['link_id'] = linkId;

          int contactId = await txn.insert(contactTbl, data);

          if (contactId <= 0) {
            throw Exception(
                "Couldn't add contact with ID : ${contact.contactId}");
          }
        }
      });
      return true;
    } catch (e, stackTrace) {
      debugPrint("Error adding link :: $e\n$stackTrace");
      return false;
    }
  }

  // update link
  Future<bool> updateLink(
      LinkEntity linkEntity, List<ContactEntity> contacts) async {
    try {
      Database db = await getDatabase();

      await db.transaction((txn) async {
        final linkData =
            LinkModel.fromEntity(linkEntity).toMap(uploadingData: true);

        int linkRowsAffected = await txn.update(
          linkTbl,
          linkData,
          where: "link_id = ?",
          whereArgs: [linkEntity.linkId],
        );

        if (linkRowsAffected == 0) {
          throw Exception(
              "Couldn't update link with ID :: ${linkEntity.linkId}");
        }

        // update contact
        for (var contact in contacts) {
          Map<String, dynamic> data =
              ContactModel.fromEntity(contact).toMap(uploadingData: true);
          data['link_id'] = linkEntity.linkId;

          int contactRowAffected = await txn.update(
            contactTbl,
            data,
            where: "contact_id = ?",
            whereArgs: [contact.contactId],
          );

          if (contactRowAffected == 0) {
            throw Exception(
                "Couldn't update contact with ID :: ${contact.contactId}");
          }
        }
      });
      return true;
    } catch (e, stackTrace) {
      debugPrint("Error updating link :: $e\n$stackTrace");
      return false;
    }
  }

  // fetch link
  Future<Either<bool, LinkEntity>> fetchLink(int linkId) async {
    try {
      Database tempDb = await getDatabase();

      final links = await tempDb.query(linkTbl,
          where: "link_id = ?", whereArgs: [linkId], limit: 1);

      if (links.isEmpty) {
        throw Exception("Link not found with ID :: $linkId");
      }

      Map<String, dynamic> data = links[0];

      final LinkEntity linkEntity = LinkModel.fromMap(data).toEntity();

      return Right(linkEntity);
    } catch (e, stackTrace) {
      debugPrint("Error fetching link :: $e\n$stackTrace");
      return Left(false);
    }
  }

  // delete link
  Future<bool> deleteLink(int linkId) async {
    try {
      Database db = await getDatabase();

      int rowsAffected = await db.delete(
        linkTbl,
        where: "link_id = ?",
        whereArgs: [linkId],
      );

      return rowsAffected > 0;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // delete contact
  Future<bool> deleteContact(int contactId) async {
    try {
      Database db = await getDatabase();

      int rowsAffected = await db.delete(
        contactTbl,
        where: "contact_id = ?",
        whereArgs: [contactId],
      );
      return rowsAffected > 0;
    } catch (e) {
      return false;
    }
  }

  // get grouped links
  Future<Either<bool, List<Map<String, dynamic>>>> getGroupedLinks() async {
    try {
      // database
      Database db = await getDatabase();

      // get links
      final List<Map<String, dynamic>> linkRepository =
          await db.rawQuery("SELECT * FROM $linkTbl ORDER BY name");

      // get contacts
      final List<Map<String, dynamic>> contactRepository =
          await db.rawQuery("SELECT * FROM $contactTbl");

      List<Map<String, dynamic>> completeLinkRepository = [];

      for (var link in linkRepository) {
        List<Map<String, dynamic>> contacts = [];
        for (var contact in contactRepository) {
          if (link['link_id'] == contact['link_id']) {
            contacts.add(contact);
          }
        }
        final Map<String, dynamic> completeLink = {
          'profile': link,
          'contacts': contacts,
        };
        completeLinkRepository.add(completeLink);
      }

      // categories
      Set<String> categories = {};
      for (var link in linkRepository) {
        link['name'] == ''
            ? categories.add('#')
            : categories.add(link['name'][0]);
      }

      List<Map<String, dynamic>> groups = [];

      List<Map<String, dynamic>> unnamedGroup = [];

      for (var category in categories) {
        if (category == '#') {
          for (var completeLink in completeLinkRepository) {
            if (completeLink['profile']['name'] == '') {
              unnamedGroup.add(completeLink);
            }
          }
        } else {
          List<Map<String, dynamic>> group = [];
          for (var completeLink in completeLinkRepository) {
            if (completeLink['profile']['name'] == '') {
              continue;
            }
            if (completeLink['profile']['name'][0] == category) {
              group.add(completeLink);
            }
          }
          groups.add(
            {
              'title': category,
              'links': group,
            },
          );
        }
      }

      if (unnamedGroup.isNotEmpty) {
        groups.add({
          'title': '#',
          'links': unnamedGroup,
        });
      }

      return Right(groups);
    } catch (e, stackTrace) {
      debugPrint("Grouped link fetch error :: $e\n$stackTrace");
      return Left(false);
    }
  }

  // fetch complete link
  Future<Either<bool, List<Map<String, dynamic>>>> fetchCompleteLink(
      int linkId) async {
    try {
      Database db = await getDatabase();

      final String sql = '''
        SELECT * FROM $linkTbl AS a
        INNER JOIN $contactTbl AS b
        ON a.link_id = b.link_id
        WHERE a.link_id = $linkId
      ''';

      final List<Map<String, dynamic>> links = await db.rawQuery(sql);

      if (links.isEmpty) {
        throw Exception("Link not found.");
      }
      return Right(links);
    } catch (e, stackTrace) {
      debugPrint("Complete link fetch error :: $e\n$stackTrace");
      return Left(false);
    }
  }

  // get categorized links
  Future<Either<bool, List<MetricEntity>>> getMetricData() async {
    try {
      final Database tempDb = await getDatabase();

      final String stmt = "SELECT * FROM $linkTbl";

      final List<Map<String, dynamic>> links = await tempDb.rawQuery(stmt);

      Map<String, dynamic> chartData = {};

      for (var category in LinkCategoryEnum.values) {
        chartData[category.label] = 0;
      }

      for (var link in links) {
        chartData[LinkCategoryEnum.getCategoryFromLabel(link['category'])!
            .label
            .toString()] += 1;
      }

      List<MetricEntity> metricData = [];

      chartData.forEach((key, value) {
        final MetricEntity metricEntity =
            MetricModel.fromMap({'title': key, 'count': value}).toEntity();
        metricData.add(metricEntity);
      });

      return Right(metricData);
    } catch (e) {
      return Left(false);
    }
  }

  // search link ny name
  Future<List<Map<String, dynamic>>> searchLinkByName(String searchText) async {
    try {
      final tempDb = await getDatabase();

      // get links
      String sql = "SELECT * FROM $linkTbl WHERE name LIKE ? ORDER BY name ASC";

      final List<Map<String, dynamic>> linkRepository =
          await tempDb.rawQuery(sql, ["%$searchText%"]);

      if (linkRepository.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> links = [];

      final List<int> linkIds = [];

      for (var link in linkRepository) {
        linkIds.add(link['link_id']);
      }

      String placeholders = List.filled(linkIds.length, '?').join(', ');

      final List<Map<String, dynamic>> contactRepository =
          await tempDb.rawQuery(
        "SELECT * FROM $contactTbl WHERE link_id IN ($placeholders)",
        linkIds.map((e) => e.toString()).toList(),
      );

      for (var link in linkRepository) {
        List<Map<String, dynamic>> contacts = [];
        for (var contact in contactRepository) {
          if (link['link_id'] == contact['link_id']) {
            contacts.add(contact);
          }
        }
        links.add({
          'profile': link,
          'contacts': contacts,
        });
      }
      return links;
    } catch (e, stackTrace) {
      debugPrint("Error fetching grouped links :: lin$e\n$stackTrace");
      return [];
    }
  }

  // search link by contact
  Future<List<Map<String, dynamic>>> searchLinkByContact(
      String searchText) async {
    try {
      final db = await getDatabase();

      // get contacts
      String query = "SELECT * FROM $contactTbl WHERE number LIKE ?";
      final List<Map<String, dynamic>> contactRepository =
          await db.rawQuery(query, ["%$searchText%"]);

      if (contactRepository.isEmpty) {
        return [];
      } else {
        // get link ids
        List<int> linkIds = [];
        for (var contact in contactRepository) {
          if (!linkIds.contains(contact['link_id'])) {
            linkIds.add(contact['link_id']);
          }
        }

        final String placeholder = List.filled(linkIds.length, '?').join(', ');

        query =
            "SELECT * FROM $linkTbl WHERE link_id IN ($placeholder) ORDER BY name ASC";

        final List<Map<String, dynamic>> linkRepository = await db.rawQuery(
          query,
          linkIds.map((e) => e.toString()).toList(),
        );

        List<Map<String, dynamic>> links = [];

        for (var link in linkRepository) {
          List<Map<String, dynamic>> contacts = [];
          for (var contact in contactRepository) {
            if (link['link_id'] == contact['link_id']) {
              contacts.add(contact);
            }
          }
          links.add({
            'profile': link,
            'contacts': contacts,
          });
        }
        return links;
      }
    } catch (e, stackTrace) {
      debugPrint("Error fetching grouped links :: lin$e\n$stackTrace");
      return [];
    }
  }

  // reset link table
  Future<bool> resetLink() async {
    try {
      Database db = await getDatabase();
      int rowsAffected = await db.delete(linkTbl);
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      debugPrint("Error resetting link table :: $e\n$stackTrace");
      return false;
    }
  }

  // reset contact table
  Future<bool> resetContact() async {
    try {
      Database db = await getDatabase();
      int rowsAffected = await db.delete(contactTbl);
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      debugPrint("Error resetting contact table :: $e\n$stackTrace");
      return false;
    }
  }

  // reset everything
  Future<bool> resetEverything() async {
    try {
      Database db = await getDatabase();

      await db.transaction((txn) async {
        await txn.delete(profileTbl);
        await txn.delete(linkTbl);
      });
      return true;
    } catch (e, stackTrace) {
      debugPrint("Error resetting everything :: $e\n$stackTrace");
      return false;
    }
  }
}
