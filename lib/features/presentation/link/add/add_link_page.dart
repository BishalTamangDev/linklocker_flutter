import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

class AddLinkPage extends StatefulWidget {
  const AddLinkPage({
    super.key,
    this.task = "add",
    Map<String, dynamic>? data,
    Map<String, dynamic>? dataSecond,
  })  : linkData = data ?? const {'id': 0},
        qrData = dataSecond ?? const {'id': 0};

  final String task;

  // final int id;
  final Map<String, dynamic> linkData;
  final Map<String, dynamic> qrData;

  @override
  State<AddLinkPage> createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<AddLinkPage> {
  // variables
  Uint8List profilePicture = Uint8List(0);
  String category = "other";
  var userModel = UserModel();
  var localDataStorage = LocalDataSource.getInstance();
  DateTime? birthday;

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var noteController = TextEditingController();
  String country = "nepal";

  @override
  void initState() {
    super.initState();

    if (widget.task == "edit") {
      _backupData();
    } else if (widget.task == "qr_add") {
      _backupQrData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // functions
  _resetData() {
    setState(() {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      noteController.clear();
      birthday = null;
      category = "other";
      country = "nepal";
      profilePicture = Uint8List(0);
    });
  }

  // backup data
  _backupData() {
    setState(() {
      nameController.text = widget.linkData['name'];
      emailController.text = widget.linkData['email'];
      noteController.text = widget.linkData['note'];
      category = widget.linkData['category'];

      birthday = widget.linkData['date_of_birth'] == ""
          ? null
          : DateTime.parse(widget.linkData['date_of_birth']);

      profilePicture = widget.linkData['profile_picture'];

      //   contacts
      country = widget.linkData['contacts'][0]['country'];
      phoneController.text = widget.linkData['contacts'][0]['contact'];
    });
  }

  _backupQrData() {
    developer.log("Backup qr data :: ${widget.qrData}");
    setState(() {
      nameController.text =
          widget.qrData['name'].toString().trim().toLowerCase();
      emailController.text = widget.qrData['email_address'] ?? "";
      country =
          widget.qrData['contact']['country'].toString().trim().toLowerCase();
      phoneController.text =
          widget.qrData['contact']['number'].toString().trim();
    });
  }

  // select profile picture
  Future<void> _pickImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();

    final XFile? image = await imagePicker.pickImage(source: imageSource);

    if (image != null) {
      //   get bytes
      var bytes = await image.readAsBytes();

      // compress image
      Uint8List compressedImage = await AppFunctions.compressImage(bytes);

      if (mounted) {
        setState(() {
          profilePicture = compressedImage;
        });
      }
    }
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
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                if (widget.task == "edit") {
                  _backupData();
                } else if (widget.task == "qr_add") {
                  _backupQrData();
                } else {
                  _resetData();
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.undo),
            ),
          ),
        ],
        title: Text(widget.task == "add"
            ? "Add New Link"
            : widget.task == "edit"
                ? "Edit Link"
                : "Adding from Qr Scan"),
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
                  const SizedBox(height: 0.0),

                  //   profile picture
                  InkWell(
                    onTap: () {
                      //   show image source
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  top: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Opacity(
                                  opacity: 0.6,
                                  child: Text("Select the image source",
                                      style: textTheme.bodyMedium),
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              ListTile(
                                title: const Text("Gallery"),
                                leading: Icon(Icons.photo_outlined),
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  context.pop();
                                },
                              ),
                              ListTile(
                                title: const Text("Camera"),
                                leading: Icon(Icons.camera_alt_outlined),
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                  context.pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundColor: colorScheme.surface,
                      backgroundImage: profilePicture.isNotEmpty
                          ? MemoryImage(profilePicture)
                          : AssetImage(AppConstants.defaultUserImage),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  profilePicture.isNotEmpty
                      ? OutlinedButton(
                          onPressed: () {
                            setState(() {
                              profilePicture = Uint8List(0);
                            });
                          },
                          child: const Text("Remove Profile Picture"),
                        )
                      : SizedBox(
                          height: 48.0,
                          child: Center(
                            child: const Text("Profile Picture"),
                          ),
                        ),

                  // const SizedBox(),

                  //   name
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: nameController,
                    hintText: "Name",
                    leadingIcon: Icons.person,
                    leadingIconColor: Colors.red,
                  ),

                  // category
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      color: colorScheme.surface,
                      width: mediaQuery.size.width - 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          spacing: 16.0,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group_add_outlined,
                              color: AppConstants.categoryIconColor,
                            ),
                            Expanded(
                              child: DropdownButton(
                                value: category,
                                elevation: 3,
                                hint: const Text("Category"),
                                underline: Container(height: 0),
                                isExpanded: true,
                                style: textTheme.bodyMedium,
                                items: [
                                  ...AppConstants.categoryList.map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                          "${category[0].toUpperCase()}${category.substring(1)}"),
                                    ),
                                  ),
                                ],
                                onChanged: (newCategory) {
                                  setState(() {
                                    category = newCategory!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // phone number
                  Row(
                    spacing: 10.0,
                    children: [
                      // call icon, country code & contact
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            color: colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                spacing: 10.0,
                                children: [
                                  // call icon
                                  Icon(
                                    Icons.call,
                                    color: AppConstants.callIconColor,
                                  ),

                                  // country code
                                  DropdownButton(
                                    value: country,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    underline: SizedBox(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        country = newValue.toString();
                                      });
                                    },
                                    items: [
                                      ...AppConstants.countryCodes.map(
                                        (countryCode) => DropdownMenuItem(
                                          value: countryCode['country'],
                                          child: Text(
                                            AppFunctions.getCapitalizedWords(
                                                countryCode['country']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //   contact
                                  Expanded(
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Phone number",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(8.0),
                      //   child: InkWell(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     onTap: () {
                      //       developer.log("Add more contact");
                      //       setState(() {});
                      //     },
                      //     child: Container(
                      //       color: colorScheme.surface,
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Icon(
                      //           Icons.add,
                      //           color: Colors.green,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // delete contact
                      // Row(
                      //   children: [
                      //     const SizedBox(width: 8.0),
                      //     ClipRRect(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //       child: InkWell(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         onTap: () {},
                      //         child: Container(
                      //           color: colorScheme.surface,
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(12.0),
                      //             child: Icon(
                      //               Icons.delete_outline,
                      //               color: Colors.red,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
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

                  //   date of birth
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: mediaQuery.size.width,
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          bottom: 20.0,
                          left: 10.0,
                          right: 18.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 16.0,
                          children: [
                            Icon(
                              Icons.cake_outlined,
                              color: AppConstants.birthdayIconColor,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Birthday"),
                                  InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: birthday,
                                        keyboardType:
                                            TextInputType.numberWithOptions(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 50),
                                        lastDate: DateTime.now(),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          birthday = pickedDate;
                                        });
                                        developer
                                            .log("Picked data :: $pickedDate");
                                      }
                                    },
                                    child: Text(
                                      birthday == null
                                          ? "Select birthday"
                                          : AppFunctions.getFormattedDate(
                                              birthday!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // note
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          spacing: 16.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(
                                Icons.note_alt_outlined,
                                color: AppConstants.noteIconColor,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 6,
                                controller: noteController,
                                decoration: InputDecoration(
                                  hintText:
                                      "Write something about this person...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            spacing: 4.0,
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
                    onPressed: () => context.pop(),
                    child: const Text("Cancel"),
                  ),
                ),
              ),

              // button :: save || update
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
                            ? nameController.text.toString().toLowerCase()
                            : "unknown",
                        'category': category,
                        'date_of_birth':
                            birthday != null ? birthday.toString() : "",
                        'email': emailController.text.toString().toLowerCase(),
                        'note': noteController.text.toString().toLowerCase(),
                        'profile_picture': profilePicture,
                      };

                      if (widget.task == "add" || widget.task == "qr_add") {
                        // add link
                        int linkId =
                            await localDataStorage.insertLink(linkData);

                        if (linkId != 0) {
                          // contact data
                          Map<String, dynamic> contactData = {
                            'country': country,
                            'contact': phoneController.text.toString(),
                          };

                          int contactId = await localDataStorage.insertContact(
                              linkId, contactData);

                          if (context.mounted) {
                            if (contactId != 0) {
                              FocusScope.of(context).unfocus();
                              response = "success";
                              _resetData();
                            }
                          }
                        }
                      } else {
                        // link data
                        var linkId = widget.linkData['link_id'];

                        // contact data
                        var contactId =
                            widget.linkData['contacts'][0]['contact_id'];
                        var contactData = {
                          'country': country,
                          'contact': phoneController.text.toString(),
                        };

                        response =
                            await localDataStorage.updateLink(linkId, linkData);

                        if (mounted) {
                          if (response == "success") {
                            response = await localDataStorage.updateContact(
                                contactId, contactData);
                          }
                        }
                      }

                      if (context.mounted) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: widget.task == "add" ||
                                    widget.task == "qr_add"
                                ? Text(response == "success"
                                    ? "Link added successfully."
                                    : "Link couldn't be added.")
                                : Text(response == "success"
                                    ? "Link updated successfully."
                                    : "Link couldn't be updated."),
                          ),
                        );

                        if (widget.task == "edit" || widget.task == "qr_add") {
                          if (response == "success") {
                            context.pop();
                          }
                        }
                      }
                    },
                    child: Text(widget.task == "add" || widget.task == "qr_add"
                        ? "Add"
                        : "Update"),
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
