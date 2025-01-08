import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';

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
                userModel.setId = snapshot.data['user_id'] ?? 0;
                userModel.setName = snapshot.data['name'] ?? "";
                userModel.setEmail = snapshot.data['email'] ?? "";

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
                              Theme.of(context).colorScheme.secondary,
                          backgroundImage: AssetImage('assets/images/user.jpg'),
                        ),
                      ),
                      title: Text(userModel.getName?.isNotEmpty
                          ? userModel.name.toString()
                          : "-"),
                      subtitle: Opacity(
                        opacity: 0.6,
                        child: Text(
                          "My Profile",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showUserQrCode(snapshot.data!['name']);
                        },
                        icon: Icon(Icons.share),
                      ),
                      onTap: () {
                        if (snapshot.data['user_id'] == null) {
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
                    leading: CircularProgressIndicator(),
                    title: Opacity(
                      opacity: 0.6,
                      child: Text("Loading your details..."),
                    ),
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
  void showUserQrCode(String username) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(username),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/images/app_qr.png'),
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
