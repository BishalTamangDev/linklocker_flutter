import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  // variables
  late Future<dynamic> _userData;
  var userModel = UserModel();
  var localDataSource = LocalDataSource.getInstance();

  @override
  void initState() {
    super.initState();
    _userData = localDataSource.getUser();
  }

  // functions
  _refreshUserData() async {
    setState(() {
      _userData = localDataSource.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: FutureBuilder(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12.0),
                        const Text("An error occurred!"),
                        TextButton(
                          onPressed: () async {
                            await _refreshUserData();
                          },
                          child: const Text("Refresh"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                var userData = snapshot.data;

                userModel.setId = userData['user_id'] ?? 0;
                userModel.setName = userData['name'] ?? "";
                userModel.setEmail = userData['email'] ?? "";

                var qrData = {
                  'contact': '-',
                  'email_address': userModel.getEmail,
                  'name': userModel.getName,
                };

                return Column(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(),
                    ListTile(
                      leading: Hero(
                        tag: 'profile_picture',
                        child: CircleAvatar(
                          radius: 32.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundImage: AssetImage('assets/images/user.jpg'),
                        ),
                      ),
                      title: Text(
                        AppFunctions.getCapitalizedWords(userData['name']),
                      ),
                      subtitle: Opacity(
                        opacity: 0.6,
                        child: Text(
                          "My Profile",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      trailing: userData['user_id'] == null
                          ? null
                          : IconButton(
                              onPressed: () {
                                showUserQrCode(qrData);
                              },
                              icon: Icon(Icons.share),
                            ),
                      onTap: () {
                        if (userData['user_id'] == null) {
                          context.push('/profile/add').then((_) {
                            _refreshUserData();
                          });
                        } else {
                          context.push('/profile/view').then((_) {
                            _refreshUserData();
                          });
                        }
                      },
                    ),
                    const SizedBox(),
                  ],
                );
              }
            } else {
              return Column(
                spacing: 12.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 32.0,
                      backgroundColor: Theme.of(context).canvasColor,
                    ),
                    title: Opacity(
                      opacity: 0.6,
                      child: Text("Loading your details..."),
                    ),
                    subtitle: Text(""),
                  ),
                  const SizedBox(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // user qr code
  void showUserQrCode(Map<String, dynamic> qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppFunctions.getCapitalizedWords(qrData['name'])),
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
              child: const Text("Scan the QR code to add this contact."),
            ),
          ],
        ),
      ),
    );
  }
}
