import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFunctions {
  static String getFormattedDate(DateTime dateTime) =>
      DateFormat('d MMM, yyyy').format(dateTime).toString();

  // country code
  static String getCountryCode(String country) {
    String code = "";

    switch (country) {
      case 'nepal':
        code = "+977";
        break;
      default:
        code = "";
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

//   capitalize words
  static String getCapitalizedWords(String sentence) {
    String finalString = "";

    List<String> words = sentence.toLowerCase().split(' ');

    for (var word in words) {
      finalString += "${word[0].toUpperCase()}${word.substring(1)} ";
    }

    return finalString;
  }

//   category color
  static Color getCategoryColor(String title) {
    Map<String, dynamic> categoryMap = AppConstants.categoryColor.firstWhere(
        (map) => map.containsKey(title),
        orElse: () => {title: Colors.grey});
    return categoryMap[title];
  }

  // image picker
  static dynamic pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image;
    try {
      image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        developer.log('File path: ${image.path}');
        Uint8List bytes = await image.readAsBytes();
        developer.log('File size in bytes: ${bytes.length}');
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
  static showUserQrCode(BuildContext context, Map<String, dynamic> qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppFunctions.getCapitalizedWords(qrData['name'] ?? "Unknown")),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: QrImageView(
                  data: qrData.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "Scan the QR code above.",
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
}
