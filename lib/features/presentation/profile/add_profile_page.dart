import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key, this.task = "add"});

  final String task;

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  // variables
  late Map<String, dynamic> _userData;

  var localDataStorage = LocalDataSource.getInstance();

  FileImage? fileImage;

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.task == "edit") {
      _fetchUserData();
    }
  }

  _fetchUserData() async {
    _userData = await LocalDataSource.getInstance().getUser();
    setState(() {
      nameController.text = _userData['name'];
      emailController.text = _userData['email'];
    });
  }

  @override
  void dispose() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    fileImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeContext.canvasColor,
      appBar: AppBar(
        title: Text(widget.task == "add" ? "Add Profile" : "Edit Profile"),
        elevation: 0,
        backgroundColor: themeContext.canvasColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),

                  //   profile picture
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: colorScheme.surface,
                    child: Icon(Icons.camera_alt_outlined),
                  ),

                  Center(
                    child: const Text("Profile Picture"),
                  ),

                  const SizedBox(),

                  //   name
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: nameController,
                    hintText: "Name",
                    leadingIcon: Icons.person,
                    leadingIconColor: Colors.red,
                  ),

                  //   phone number
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: phoneController,
                    hintText: "Phone Number",
                    leadingIcon: Icons.call_outlined,
                    leadingIconColor: Colors.green,
                    textInputType: TextInputType.numberWithOptions(),
                  ),

                  //   email address
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: emailController,
                    hintText: "Email Address",
                    leadingIcon: Icons.email_outlined,
                    leadingIconColor: Colors.orangeAccent,
                    textInputType: TextInputType.emailAddress,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // button :: cancel
                    SizedBox(
                      height: 50.0,
                      width: mediaQuery.size.width / 2 - 26,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          // backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),

                    // button :: add || update
                    SizedBox(
                      height: 50.0,
                      width: mediaQuery.size.width / 2 - 26,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () async {
                          var scaffoldMessenger = ScaffoldMessenger.of(context);

                          var data = {
                            'name': nameController.text ?? '',
                            'email': emailController.text ?? '',
                          };

                          //   get values
                          developer.log("User data : $data");

                          // add profile
                          if (widget.task == "add") {
                            String response =
                                await localDataStorage.insertUser(data);

                            // user created
                            if (context.mounted) {
                              if (scaffoldMessenger.mounted) {
                                scaffoldMessenger.hideCurrentSnackBar();
                              }

                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(response == "success"
                                      ? "Profile added successfully."
                                      : "Profile couldn't be created."),
                                ),
                              );

                              await Future.delayed(const Duration(seconds: 2));

                              if (context.mounted) context.pop();
                            }
                          } else {
                            // update
                            String response =
                                await localDataStorage.updateUser(data);

                            if (context.mounted) {
                              if (scaffoldMessenger.mounted) {
                                scaffoldMessenger.hideCurrentSnackBar();
                              }

                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(response == "success"
                                      ? "Profile updated successfully."
                                      : "Couldn't update profile."),
                                ),
                              );

                              if (response == "success") {
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                if (context.mounted) context.pop();
                              }
                            }
                          }
                        },
                        child: Text(widget.task == "add" ? "Save" : "Update"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
