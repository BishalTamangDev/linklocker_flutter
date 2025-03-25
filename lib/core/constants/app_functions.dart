import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum LinkCategory {
  businessPartner,
  client,
  coworker,
  doctor,
  emergency,
  family,
  friend,
  investor,
  lawyer,
  relative,
  serviceProvider,
  student,
  teacher,
  other;

  String get label {
    switch (this) {
      case LinkCategory.businessPartner:
        return "Business Partner";
      case LinkCategory.client:
        return "Client";
      case LinkCategory.coworker:
        return "Coworker";
      case LinkCategory.doctor:
        return "Doctor";
      case LinkCategory.emergency:
        return "Emergency";
      case LinkCategory.family:
        return "Family";
      case LinkCategory.friend:
        return "Friend";
      case LinkCategory.investor:
        return "Investor";
      case LinkCategory.lawyer:
        return "Lawyer";
      case LinkCategory.relative:
        return "Relative";
      case LinkCategory.serviceProvider:
        return "Service Provider";
      case LinkCategory.student:
        return "Student";
      case LinkCategory.teacher:
        return "Teacher";
      case LinkCategory.other:
        return "Other";
    }
  }

  Color get color {
    switch (this) {
      case LinkCategory.businessPartner:
        return Colors.pink;
      case LinkCategory.client:
        return Colors.indigo;
      case LinkCategory.coworker:
        return Colors.purple;
      case LinkCategory.doctor:
        return Colors.cyan;
      case LinkCategory.emergency:
        return Colors.red;
      case LinkCategory.family:
        return Colors.orange;
      case LinkCategory.friend:
        return Colors.blue;
      case LinkCategory.investor:
        return Colors.lime;
      case LinkCategory.lawyer:
        return Colors.deepPurple;
      case LinkCategory.relative:
        return Colors.green;
      case LinkCategory.serviceProvider:
        return Colors.amber;
      case LinkCategory.student:
        return Colors.teal;
      case LinkCategory.teacher:
        return Colors.brown;
      case LinkCategory.other:
        return Colors.grey;
    }
  }
}

class AppFunctions {
  static String getFormattedDate(DateTime dateTime) =>
      DateFormat('d MMM, yyyy').format(dateTime).toString();

  // country code
  static String getCountryCode(String country) {
    String code = "+977";

    for (var countryCode in AppConstants.countryCodes) {
      if (countryCode['country'] == country) {
        code = countryCode['code'];
      }
    }

    return code;
  }

  // capitalize word
  static String getCapitalizedWord(String word) {
    String finalWord = "";

    word = word.toLowerCase();

    finalWord = word[0].toUpperCase() + word.substring(1);

    return finalWord;
  }

  // capitalize words
  static String getCapitalizedWords(String sentence) {
    String finalString = "";

    List<String> words = sentence.toLowerCase().split(' ');

    for (var word in words) {
      finalString += "${word[0].toUpperCase()}${word.substring(1)} ";
    }

    return finalString;
  }

  // category color
  static Color getCategoryColor(String title) {
    Map<String, dynamic> categoryMap = AppConstants.categoryColor.firstWhere(
        (map) => map.containsKey(title),
        orElse: () => {title: Colors.black});
    return categoryMap[title];
  }

  // image picker
  static dynamic pickImage(ImageSource imageSource) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image;
    try {
      image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        // developer.log('File path: ${image.path}');
        Uint8List bytes = await image.readAsBytes();
        // developer.log('File size in bytes: ${bytes.length}');
        return bytes;
      }
    } catch (e) {
      developer.log("Picking mage error :: $e");
    }
  }

  // call pad launcher
  static void openDialer(String number) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: number,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw "An error occurred!";
    }
  }

  // user qr code
  static showProfileQrCode({
    required BuildContext context,
    required ProfileEntity profileEntity,
    required List<ProfileContactEntity> contacts,
  }) {
    List<Map<String, dynamic>> contactList = [];

    for (var contact in contacts) {
      contactList.add({
        'country': contact.country ?? AppConstants.defaultCountry,
        'number': contact.contactNumber ?? ''
      });
    }

    final Map<String, dynamic> qrData = {
      'name': profileEntity.name ?? '-',
      'contacts': contactList,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 12.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppFunctions.getCapitalizedWords(qrData['name']),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: QrImageView(
                  data: jsonEncode(qrData['contacts']),
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "Scan the QR code above to add this contact.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // share qr old
  static showUserQrCodeOld(BuildContext context, Map<String, dynamic> qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 12.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              qrData['name'] != null
                  ? qrData['name'].toString().toUpperCase()
                  : "-",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: QrImageView(
                  data: jsonEncode(qrData),
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "Scan the QR code above to add this contact.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottom sheet call
  static showCallBottomSheet(
      BuildContext context, List<Map<String, dynamic>> contacts) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 1.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...contacts.map(
                    (contact) => ListTile(
                      title: Text(
                          "${AppFunctions.getCountryCode(contact['country'])} ${contact['contact']}"),
                      trailing: OutlinedButton(
                        onPressed: () =>
                            AppFunctions.openDialer("${contact['contact']}"),
                        child: const Text("Call Now"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // compress Uint8List and get another Uint8List.
  static Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 10,
      rotate: 0,
    );
    return result;
  }

  static bool checkQrValidity(Map<String, dynamic> linkData) {
    bool status = true;

    developer.log("Link data :: $linkData");

    if (linkData['name'] == null ||
        linkData['contact']['country'] == null ||
        linkData['contact']['number'] == null) {
      status = false;
    }

    return status;
  }
}
