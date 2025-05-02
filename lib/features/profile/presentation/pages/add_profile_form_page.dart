import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linklocker/core/constants/color_constants.dart';
import 'package:linklocker/core/constants/county_codes.dart';
import 'package:linklocker/core/constants/string_constants.dart';
import 'package:linklocker/core/utils/image_compressor_utils.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/shared/widgets/custom_text_field_widget.dart';

import '../blocs/add_profile/add_profile_bloc.dart';

class AddProfileFormPage extends StatefulWidget {
  const AddProfileFormPage({
    super.key,
    this.task = "add",
    required this.profileEntity,
    required this.profileContactEntity,
  });

  final String task;
  final ProfileEntity profileEntity;
  final ProfileContactEntity profileContactEntity;

  @override
  State<AddProfileFormPage> createState() => _AddProfileFormPageState();
}

class _AddProfileFormPageState extends State<AddProfileFormPage> {
  // variables
  String country = StringConstants.defaultCountry;
  Uint8List profilePicture = Uint8List(0);

  // controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // backup data function
  _backupData() {
    // profile
    nameController.text = widget.profileEntity.name ?? '';
    profilePicture = widget.profileEntity.profilePicture ?? Uint8List(0);
    emailController.text = widget.profileEntity.emailAddress ?? '';

    // contact
    numberController.text = widget.profileContactEntity.number ?? '';
    country = widget.profileContactEntity.country ?? StringConstants.defaultCountry;
  }

  // image picker
  Future<void> _pickImage(ImageSource imageSource) async {
    FocusScope.of(context).unfocus();
    try {
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();

        // compress image
        final Uint8List compressedImage = await ImageCompressUtils.compressImage(bytes);

        if (mounted) {
          setState(() {
            profilePicture = compressedImage;
          });
        }
      }
    } catch (e) {
      debugPrint("Error occurred!");
    }
  }

  // proceed
  Future<void> _proceed() async {
    final addProfileBloc = context.read<AddProfileBloc>();
    // check for data
    if (nameController.text.trim().isEmpty || numberController.text.trim().isEmpty) {
      addProfileBloc.add(
        AddProfileSnackBarEvent("Please enter both contact number and your name."),
      );
    } else {
      final ProfileEntity newProfileEntity = ProfileEntity(
        id: widget.task == "add" ? 0 : widget.profileEntity.id,
        name: nameController.text.toString().trim().toLowerCase(),
        emailAddress: emailController.text.toString().trim(),
        profilePicture: profilePicture,
      );

      final ProfileContactEntity newContactEntity = ProfileContactEntity(
        contactId: widget.task == "add" ? 0 : widget.profileContactEntity.contactId,
        profileId: widget.task == "add" ? 0 : widget.profileContactEntity.profileId,
        number: numberController.text.toString().trim(),
        country: country,
      );

      if (widget.task == 'add') {
        addProfileBloc.add(
          AddProfileAddEvent(profileEntity: newProfileEntity, contacts: [newContactEntity]),
        );
      } else {
        addProfileBloc.add(AddProfileUpdateEvent(profileEntity: newProfileEntity, contacts: [newContactEntity]));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task == "update") {
      _backupData();
      debugPrint("Get initial data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),

                  //   profile picture
                  Center(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        // show image source
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Text("Select the image source", style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                ListTile(
                                  title: const Text("Gallery"),
                                  leading: const Icon(Icons.photo_outlined),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    context.pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text("Camera"),
                                  leading: const Icon(Icons.camera_alt_outlined),
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
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        backgroundImage: profilePicture.isNotEmpty ? MemoryImage(profilePicture) : AssetImage(StringConstants.defaultUserImage),
                        child: const Icon(Icons.image_outlined, size: 28.0),
                      ),
                    ),
                  ),

                  profilePicture.isEmpty
                      ? const SizedBox(
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

                  // name
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: nameController,
                    hintText: "Name",
                    leadingIcon: Icons.person,
                    leadingIconColor: Colors.red,
                  ),

                  // contact number
                  Row(
                    spacing: 10.0,
                    children: [
                      // call icon, country code & contact
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
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
                                    color: ColorConstants.callIconColor,
                                  ),

                                  // country code
                                  DropdownButton(
                                    value: country,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    underline: SizedBox(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        country = newValue.toString();
                                      });
                                    },
                                    items: [
                                      ...countryCodes.map(
                                        (countryCode) => DropdownMenuItem(
                                          value: countryCode['country'],
                                          child: Text(
                                            StringUtils.getCapitalizedWords(countryCode['country']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // contact
                                  Expanded(
                                    child: TextField(
                                      controller: numberController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Contact number",
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
                ],
              ),
            ),
          ),

          // bottom actions
          SafeArea(
            child: SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _proceed,
                child: Text(widget.task == "add" ? "Save" : "Update"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
