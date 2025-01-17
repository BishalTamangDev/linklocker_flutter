import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:linklocker/data/source/local/local_data_source.dart';
import 'package:share_plus/share_plus.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.profileData});

  final Map<String, dynamic> profileData;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  // variables
  late Map<String, dynamic> userData;

  // functions
  _refreshUserData() async {
    userData = await LocalDataSource.getInstance().getUser();
    setState(() {});
  }

  @override
  void initState() {
    userData = _getInitialData();
    super.initState();
  }

  Map<String, dynamic> _getInitialData() {
    return widget.profileData;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        title: const Text("My Profile"),
      ),
      backgroundColor: themeContext.canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32.0),

              //   profile picture
              Center(
                child: Column(
                  spacing: 18.0,
                  children: [
                    // profile picture
                    CircleAvatar(
                        radius: 80.0,
                        backgroundColor: colorScheme.surface,
                        backgroundImage:
                            userData['profile_picture'].isNotEmpty
                                ? MemoryImage(userData['profile_picture'])
                                : AssetImage(AppConstants.defaultUserImage)),
                    Text(
                        AppFunctions.getCapitalizedWords(
                          userData['name'],
                        ),
                        style: textTheme.headlineSmall),
                  ],
                ),
              ),

              const SizedBox(),

              //   contacts
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        ...userData['contacts'].map(
                          (contact) => ListTile(
                            leading: Icon(
                              Icons.phone_outlined,
                              color: AppConstants.callIconColor,
                            ),
                            title: Text(
                                "${AppFunctions.getCountryCode(contact['country'])} ${contact['contact']}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // email
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                            color: AppConstants.emailIconColor,
                          ),
                          title: Text(
                            userData['email'] != "" ? userData['email'] : "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // bottom actions
      bottomNavigationBar: Container(
        color: colorScheme.surface,
        width: mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // contact qr code
              Expanded(
                child: InkWell(
                  onTap: () {
                    Map<String, dynamic> qrData = {
                      'name': AppFunctions.getCapitalizedWords(userData['name'])
                          .trim(),
                      'email_address': userData['email'].toString().trim(),
                      'contact': {
                        "country": AppFunctions.getCapitalizedWords(
                                userData['contacts'][0]['country'])
                            .trim(),
                        "number": userData['contacts'][0]['contact'].toString().trim(),
                      },
                    };

                    AppFunctions.showUserQrCode(context, qrData);
                  },
                  splashColor: colorScheme.surface, // Custom splash color
                  highlightColor: colorScheme.surface,
                  child: Column(
                    spacing: 6.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.qr_code), const Text("QR Code")],
                  ),
                ),
              ),

              //   edit
              Expanded(
                child: InkWell(
                  onTap: () =>
                      context.push('/profile/edit', extra: userData).then(
                            (_) => _refreshUserData(),
                          ),
                  splashColor: colorScheme.surface,
                  highlightColor: colorScheme.surface,
                  child: Column(
                    spacing: 6.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit),
                      const Text("Edit"),
                    ],
                  ),
                ),
              ),

              //   share
              Expanded(
                child: InkWell(
                  onTap: () {
                    String shareName =
                        AppFunctions.getCapitalizedWords(userData['name']);
                    String shareContact =
                        "${AppFunctions.getCountryCode(userData['contacts'][0]['country'])} ${userData['contacts'][0]['contact']}";
                    String shareData = "$shareName, $shareContact";
                    Share.share(shareData);
                  },
                  splashColor: colorScheme.surface,
                  highlightColor: colorScheme.surface,
                  child: Column(
                    spacing: 6.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.share), const Text("Share")],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
