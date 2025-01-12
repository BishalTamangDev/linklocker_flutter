import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({
    super.key,
    this.task = "add",
    Map<String, dynamic>? profileData,
  }) : backupData = profileData ?? const {};

  final Map<String, dynamic> backupData;

  final String task;

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  // variables
  // late Map<String, dynamic> _userData;
  var _isDisposed = false;

  // user model
  UserModel userModel = UserModel();

  var localDataStorage = LocalDataSource.getInstance();

  Uint8List profilePicture = Uint8List(0);

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  // backup data function
  _backupData() {
    setState(() {
      nameController.text = widget.backupData['name'];
      emailController.text = widget.backupData['email'];
      profilePicture = widget.backupData['profile_picture'];
    });
  }

  // reset data function
  _resetData() {
    setState(() {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      profilePicture = Uint8List(0);
    });
  }

  // image picker
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      developer.log("Image :: ${image.path}");
      developer.log("Image bytes :: ${bytes.length}");

      setState(() {
        profilePicture = bytes;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.task == "edit") {
      _backupData();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: themeContext.canvasColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              highlightColor: Colors.transparent,
              onPressed: widget.task == "add" ? _resetData() : _backupData(),
              icon: Icon(Icons.undo_outlined),
            ),
          ),
        ],
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
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundColor: colorScheme.surface,
                      backgroundImage: profilePicture.isNotEmpty
                          ? MemoryImage(profilePicture)
                          : AssetImage(AppConstants.defaultUserImage),
                      child: Icon(
                        Icons.image_outlined,
                        size: 28.0,
                      ),
                    ),
                  ),

                  profilePicture.isEmpty
                      ? SizedBox(
                          height: 48.0,
                          child: Center(
                            child: Opacity(
                              opacity: 0.6,
                              child: Text("Select profile picture"),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  profilePicture = Uint8List(0);
                                });
                              },
                              child: const Text("Remove Profile Picture"),
                            ),
                          ],
                        ),

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

                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              // button :: cancel
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ),

              // button :: add || update
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () async {
                      var scaffoldMessenger = ScaffoldMessenger.of(context);

                      if (scaffoldMessenger.mounted) {
                        scaffoldMessenger.hideCurrentSnackBar();
                      }

                      if (nameController.text.isEmpty) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: const Text(
                                "Name is required to set up profile."),
                          ),
                        );
                        return;
                      }

                      // user model
                      userModel.setName = nameController.text.toString().trim();
                      userModel.setEmail =
                          emailController.text.toString().trim();
                      userModel.setProfilePicture = profilePicture;

                      //   get values
                      developer.log("User data : $userModel");

                      // add profile
                      if (widget.task == "add") {
                        String response =
                            await localDataStorage.insertUser(userModel);

                        // user created
                        if (mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(response == "success"
                                  ? "Profile created successfully."
                                  : "Profile couldn't be created."),
                            ),
                          );

                          if (response == "success") {
                            setState(() {
                              profilePicture = Uint8List(0);
                            });
                          }

                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      } else {
                        // update
                        String response =
                            await localDataStorage.updateUser(userModel);

                        if (context.mounted) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(response == "success"
                                  ? "Profile updated successfully."
                                  : "Couldn't update profile."),
                            ),
                          );

                          if (response == "success") {
                            context.pop();
                          }
                        }
                      }
                    },
                    child: Text(widget.task == "add" ? "Save" : "Update"),
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
