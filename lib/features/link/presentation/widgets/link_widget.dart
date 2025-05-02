import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/color_constants.dart';
import 'package:linklocker/core/constants/string_constants.dart';
import 'package:linklocker/core/utils/bottom_sheet_utils.dart';
import 'package:linklocker/core/utils/call_pad_utils.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({super.key, required this.linkEntity, required this.contacts});

  final LinkEntity linkEntity;
  final List<Map<String, dynamic>> contacts;

  @override
  Widget build(BuildContext context) {
    final countryCode = StringUtils.getCountryCode(contacts[0]['country'] ?? StringConstants.defaultCountry);
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
                : AssetImage(StringConstants.defaultUserImage),
          ),
          title: linkEntity.name == '' ? Text("Unknown") : Text(StringUtils.getCapitalizedWords(linkEntity.name!)),
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
            color: ColorConstants.callIconColor,
            onPressed: () {
              if (contacts.length == 1) {
                // launch bottom sheet if link has only one contacts
                final String countryCode = StringUtils.getCountryCode(contacts[0]['country']!);
                final String number = contacts[0]['number']!;
                CallPadUtils.openDialer("$countryCode $number");
              } else {
                BottomSheetUtils.showCallBottomSheet(context, contacts);
              }
            },
            icon: const Icon(Icons.call),
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
