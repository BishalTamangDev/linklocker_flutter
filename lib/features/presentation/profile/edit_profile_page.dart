import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // variables
  FileImage? fileImage;

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        title: const Text("Edit Profile"),
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
                  ),

                  //   email address
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: emailController,
                    hintText: "Email Address",
                    leadingIcon: Icons.email_outlined,
                    leadingIconColor: Colors.orangeAccent,
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

                    // button :: save
                    SizedBox(
                      height: 50.0,
                      width: mediaQuery.size.width / 2 - 26,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () {
                          //   get values
                          developer.log("Name : ${nameController.text}");
                          developer
                              .log("Phone number : ${phoneController.text}");
                          developer
                              .log("Email address : ${emailController.text}");
                        },
                        child: const Text("Save"),
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
