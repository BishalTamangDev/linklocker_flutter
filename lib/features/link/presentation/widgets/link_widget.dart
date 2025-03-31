import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/functions/app_functions.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({super.key, required this.linkEntity, required this.contacts});

  final LinkEntity linkEntity;
  final List<Map<String, dynamic>> contacts;

  @override
  Widget build(BuildContext context) {
    final countryCode = AppFunctions.getCountryCode(contacts[0]['country'] ?? AppConstants.defaultCountry);
    final number = contacts[0]['number'] ?? '';
    return Column(
      children: [
        const SizedBox(height: 5.0),
        ListTile(
          onTap: () => context.push('/link/view/${linkEntity.linkId}'),
          leading: CircleAvatar(
            radius: 24.0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundImage: linkEntity.profilePicture != Uint8List(0) && linkEntity.profilePicture!.isNotEmpty
                ? MemoryImage(linkEntity.profilePicture!)
                : AssetImage(AppConstants.defaultUserImage),
          ),
          title: linkEntity.name == '' ? Text("Unknown") : Text(AppFunctions.getCapitalizedWords(linkEntity.name!)),
          subtitle: SizedBox(
            child: Wrap(
              children: [
                if (contacts.isNotEmpty)
                  Text(
                    "$countryCode $number",
                    style: TextStyle(fontSize: 15.0),
                  ),
              ],
            ),
          ),
          trailing: IconButton(
            color: AppConstants.callIconColor,
            onPressed: () {
              if (contacts.length == 1) {
                // launch bottom sheet if link has only one contacts
                final countryCode = AppFunctions.getCountryCode(contacts[0]['country']!);
                final number = contacts[0]['number']!;
                AppFunctions.openDialer("$countryCode $number");
              } else {
                AppFunctions.showCallBottomSheet(context, contacts);
              }
            },
            icon: Icon(Icons.call),
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
