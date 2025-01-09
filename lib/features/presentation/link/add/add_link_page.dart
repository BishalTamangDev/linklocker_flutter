import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

class AddLinkPage extends StatefulWidget {
  const AddLinkPage({
    super.key,
    this.task = "add",
    this.id = 0,
  });

  final String task;
  final int id;

  @override
  State<AddLinkPage> createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<AddLinkPage> {
  // variables
  String category = "other";
  var userModel = UserModel();
  var localDataStorage = LocalDataSource.getInstance();

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _resetData();
    super.dispose();
  }

  // functions
  _resetData() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    noteController.clear();
    category = "others";
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: themeContext.canvasColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeContext.canvasColor,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(widget.task == "add" ? "Add New Link" : "Edit Link"),
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
                  const SizedBox(height: 32.0),

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
                    textInputType: TextInputType.number,
                  ),

                  //   category
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(
                          width: 2.0,
                          color: colorScheme.surface,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: DropdownMenu(
                        width: mediaQuery.size.width,
                        label: const Text("Category"),
                        leadingIcon: Icon(
                          Icons.group_add_outlined,
                          color: Colors.blue,
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            colorScheme.surface,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        trailingIcon: Icon(Icons.keyboard_arrow_down_sharp),
                        onSelected: (newValue) {
                          setState(() {
                            category = newValue!;
                          });
                        },
                        initialSelection: category,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: 'family', label: 'Family'),
                          DropdownMenuEntry(value: 'friend', label: 'Friend'),
                          DropdownMenuEntry(
                              value: 'relative', label: 'Relative'),
                          DropdownMenuEntry(value: 'teacher', label: 'Teacher'),
                          DropdownMenuEntry(
                              value: 'coworker', label: 'Coworker'),
                          DropdownMenuEntry(value: 'other', label: 'Other'),
                        ],
                      ),
                    ),
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

                  // note
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: noteController,
                    hintText: "Note",
                    leadingIcon: Icons.note_alt_outlined,
                    leadingIconColor: Colors.grey,
                    maxLine: 6,
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),

                    // button :: save || update
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
                          String response = "";

                          if (scaffoldMessenger.mounted) {
                            scaffoldMessenger.hideCurrentSnackBar();
                          }

                          // phone number is mandatory
                          if (phoneController.text.isEmpty) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content:
                                    const Text("Enter the phone number first."),
                              ),
                            );
                            return;
                          }

                          // link data
                          var linkData = {
                            'name': nameController.text.isNotEmpty
                                ? nameController.text.toString()
                                : "unknown",
                            'category': category,
                            'email': emailController.text.toString(),
                            'note': noteController.text.toString(),
                          };

                          developer.log("Link data: $linkData");

                          if (widget.task == "add") {
                            // add link
                            int linkId =
                                await localDataStorage.insertLink(linkData);

                            developer.log("Link ID :: $linkId");

                            if (linkId != 0) {
                              // contact data
                              Map<String, dynamic> contactData = {
                                'country': 'nepal',
                                'contact': phoneController.text.toString(),
                              };

                              developer.log("Contact data: $contactData");

                              int contactId = await localDataStorage
                                  .insertContact(linkId, contactData);

                              developer.log("Contact id :: $contactId");

                              if (context.mounted) {
                                if (contactId != 0) {
                                  response = "success";
                                  FocusScope.of(context).unfocus();
                                  _resetData();
                                }
                              }
                            }
                          } else {
                            response = await localDataStorage.updateContact(
                                widget.id, linkData);
                          }

                          if (context.mounted) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: widget.task == "add"
                                    ? Text(response == "success"
                                        ? "Link added successfully."
                                        : "Link couldn't be added.")
                                    : Text(response == "success"
                                        ? "Link updated successfully."
                                        : "Link couldn't be updated."),
                              ),
                            );
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
