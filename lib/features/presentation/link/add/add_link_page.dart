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
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    noteController.clear();
    category = "others";
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
                          // backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () {
                          //   clear values
                          Navigator.pop(context);
                        },
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
                          developer.log("Category : $category");
                          developer
                              .log("Email address : ${emailController.text}");
                          developer.log("Note: ${noteController.text}");
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
