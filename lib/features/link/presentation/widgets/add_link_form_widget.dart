import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';
import 'package:linklocker/features/link/presentation/blocs/link_add/link_add_bloc.dart';
import 'package:linklocker/shared/widgets/custom_snackbar_widget.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/functions/app_functions.dart';
import '../../../../shared/widgets/custom_text_field_widget.dart';
import '../../domain/entities/contact_entity.dart';

class AddLinkFormWidget extends StatefulWidget {
  const AddLinkFormWidget({
    super.key,
    required this.task,
    required this.linkEntity,
    required this.contacts,
  });

  final String task;
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  @override
  State<AddLinkFormWidget> createState() => _AddLinkFormWidgetState();
}

class _AddLinkFormWidgetState extends State<AddLinkFormWidget> {
  // variables
  Uint8List profilePicture = Uint8List(0);
  String category = LinkCategoryEnum.other.label;
  DateTime? birthday;

  // controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var noteController = TextEditingController();
  String country = AppConstants.defaultCountry;

  // functions
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

  // reset form
  void _resetData() {
    setState(() {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      noteController.clear();
      birthday = null;
      category = LinkCategoryEnum.other.label;
      country = AppConstants.defaultCountry;
      profilePicture = Uint8List(0);
    });
  }

  // backup data
  void _backupData() {
    ContactEntity contactEntity = widget.contacts[0];

    if (widget.task == 'update') {
      setState(() {
        nameController.text = widget.linkEntity.name ?? '';
        emailController.text = widget.linkEntity.emailAddress ?? '';
        noteController.text = widget.linkEntity.note ?? '';
        category = LinkCategoryEnum.getCategoryFromLabel(widget.linkEntity.category!.label)!.label;
        birthday = widget.linkEntity.dateOfBirth;
        profilePicture = widget.linkEntity.profilePicture ?? Uint8List(0);

        // contact
        country = contactEntity.country ?? AppConstants.defaultCountry;
        phoneController.text = contactEntity.number ?? '';
      });
    } else {
      // contact
      country = contactEntity.country ?? AppConstants.defaultCountry;
      phoneController.text = contactEntity.number ?? '';
    }
  }

  // add || update
  Future<void> _proceed() async {
    FocusScope.of(context).unfocus();

    // check data
    if (phoneController.text.isEmpty) {
      CustomSnackBarWidget.show(context: context, message: "Enter the phone number first.");
      return;
    }

    LinkEntity linkEntity = LinkEntity(
      linkId: widget.task == "add" ? 0 : widget.linkEntity.linkId ?? 0,
      name: nameController.text.toString().toLowerCase().trim(),
      category: LinkCategoryEnum.getCategoryFromLabel(category),
      emailAddress: emailController.text.toString().trim().toLowerCase(),
      dateOfBirth: birthday,
      note: noteController.text.toString().toLowerCase().trim(),
      profilePicture: profilePicture,
    );

    final List<ContactEntity> contacts = [
      ContactEntity(
        linkId: widget.task == "add" ? 0 : widget.linkEntity.linkId ?? 0,
        contactId: widget.task == "add" ? 0 : widget.contacts[0].contactId ?? 0,
        country: country,
        number: phoneController.text.toString(),
      ),
    ];

    if (widget.task == "add" || widget.task == "qr_add") {
      context.read<LinkAddBloc>().add(LinkAddAddEvent(linkEntity: linkEntity, contacts: contacts));
    } else if (widget.task == "update") {
      context.read<LinkAddBloc>().add(LinkAddUpdateEvent(linkEntity: linkEntity, contacts: contacts));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // listener
          BlocListener<LinkAddBloc, LinkAddState>(
            listenWhen: (previous, current) => current is LinkAddActionState,
            listener: (context, state) {
              if (state is LinkAddResetActionState || state is LinkAddAddedActionState) {
                _resetData();
              } else if (state is LinkAddBackupActionState) {
                _backupData();
              }
            },
            child: SizedBox.shrink(),
          ),

          // form
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 0.0),

                  // profile picture
                  InkWell(
                    onTap: () {
                      // how image source
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
                                  child: Text("Select the image source", style: Theme.of(context).textTheme.bodyLarge),
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
                                  context.pop();
                                  _pickImage(ImageSource.camera);
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
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      backgroundImage: profilePicture.isNotEmpty ? MemoryImage(profilePicture) : AssetImage(AppConstants.defaultUserImage),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
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
                      : const SizedBox(
                          height: 48.0,
                          child: Center(
                            child: Text("Profile Picture"),
                          ),
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

                  // category
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width - 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          spacing: 16.0,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.group_add_outlined, color: AppConstants.categoryIconColor),
                            Expanded(
                              child: DropdownButton(
                                value: category,
                                elevation: 3,
                                hint: const Text("Category"),
                                underline: Container(height: 0),
                                isExpanded: true,
                                style: Theme.of(context).textTheme.bodyMedium,
                                items: [
                                  ...LinkCategoryEnum.values.map((cat) => DropdownMenuItem(value: cat.label, child: Text(cat.label))),
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
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                spacing: 10.0,
                                children: [
                                  // call icon
                                  Icon(Icons.call, color: AppConstants.callIconColor),

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
                                      ...AppConstants.countryCodes.map(
                                        (countryCode) => DropdownMenuItem(
                                          value: countryCode['country'],
                                          child: Text(AppFunctions.getCapitalizedWords(countryCode['country'])),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //   contact
                                  Expanded(
                                    child: TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(hintText: "Phone number", border: InputBorder.none),
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

                  // email address
                  CustomTextFieldWidget(
                    context: context,
                    autofocus: false,
                    controller: emailController,
                    hintText: "Email Address",
                    leadingIcon: Icons.email_outlined,
                    leadingIconColor: Colors.orangeAccent,
                    textInputType: TextInputType.emailAddress,
                  ),

                  // date of birth
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 20.0, left: 10.0, right: 18.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          spacing: 16.0,
                          children: [
                            Icon(Icons.cake_outlined, color: AppConstants.birthdayIconColor),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Birthday"),
                                  InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      final DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: birthday,
                                        keyboardType: TextInputType.numberWithOptions(),
                                        firstDate: DateTime(DateTime.now().year - 50),
                                        lastDate: DateTime.now(),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          birthday = pickedDate;
                                        });
                                      }
                                    },
                                    child: Row(
                                      spacing: 8.0,
                                      children: [
                                        Text(birthday == null ? "Select birthday" : AppFunctions.getFormattedDate(birthday!)),
                                        const Icon(Icons.date_range, size: 16.0),
                                      ],
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
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        child: Row(
                          spacing: 16.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(Icons.note_alt_outlined, color: AppConstants.noteIconColor),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 6,
                                controller: noteController,
                                decoration: InputDecoration(
                                  hintText: "Write something about this person...",
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
            ),
          ),

          const SizedBox(height: 16.0),

          // action
          SizedBox(
            height: 54.0,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _proceed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: widget.task == 'update' ? Text("Update") : Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}
