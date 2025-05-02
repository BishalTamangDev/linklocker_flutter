import 'package:flutter/material.dart';
import 'package:linklocker/core/utils/call_pad_utils.dart';
import 'package:linklocker/core/utils/string_utils.dart';

class BottomSheetUtils {
  static showCallBottomSheet(BuildContext context, List<Map<String, dynamic>> contacts) {
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
                      title: Text("${StringUtils.getCountryCode(contact['country'])} ${contact['contact']}"),
                      trailing: OutlinedButton(
                        onPressed: () => CallPadUtils.openDialer("${contact['contact']}"),
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
}
