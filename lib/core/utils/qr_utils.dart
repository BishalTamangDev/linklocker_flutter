import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/string_constants.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../features/link/domain/entities/contact_entity.dart';
import '../../features/link/domain/entities/link_entity.dart';
import '../../features/profile/domain/entities/profile_contact_entity.dart';
import '../../features/profile/domain/entities/profile_entity.dart';

class QrUtils {
  // profile qr code
  static showProfileQrCode({
    required BuildContext context,
    required ProfileEntity profileEntity,
    required List<ProfileContactEntity> contacts,
  }) {
    List<Map<String, dynamic>> contactList = [];

    for (var contact in contacts) {
      contactList.add({'country': contact.country ?? StringConstants.defaultCountry, 'number': contact.number ?? ''});
    }

    Map<String, dynamic> qrData = {
      'name': profileEntity.name ?? '-',
      'contacts': contactList,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            spacing: 12.0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StringUtils.getCapitalizedWords(qrData['name']),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
        );
      },
    );
  }

  // share general qr code
  static showQrCode({
    required BuildContext context,
    required LinkEntity linkEntity,
    required List<ContactEntity> contacts,
  }) {
    List<Map<String, dynamic>> contactList = [];

    for (var contact in contacts) {
      contactList.add({'country': contact.country ?? StringConstants.defaultCountry, 'number': contact.number ?? ''});
    }

    Map<String, dynamic> qrData = {
      'name': linkEntity.name ?? '-',
      'contacts': contactList,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            spacing: 12.0,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                StringUtils.getCapitalizedWords(qrData['name']),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
        );
      },
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
              qrData['name'] != null ? qrData['name'].toString().toUpperCase() : "-",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
}
