import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/functions/app_functions.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/presentation/blocs/add_profile/add_profile_bloc.dart';
import 'package:linklocker/shared/widgets/custom_snackbar_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/view_profile/view_profile_bloc.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  // functions
  _deleteProfile() async {
    context.pop();
    context.read<ViewProfileBloc>().add(ViewProfileDeleteProfileEvent());
  }

  // alert dialog
  void _showDeleteAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
          title: const Text('Delete Profile'),
          content: Opacity(
            opacity: 0.6,
            child: const Text('Are you sure you want to delete your profile?'),
          ),
          actions: [
            OutlinedButton(
              onPressed: _deleteProfile,
              child: const Text("Yes"),
            ),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        title: const Text("My Profile"),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: _showDeleteAlert,
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocConsumer<ViewProfileBloc, ViewProfileState>(
        listenWhen: (previous, current) => current is ViewProfileActionState,
        buildWhen: (previous, current) => current is! ViewProfileActionState,
        listener: (context, state) async {
          if (state is ViewProfileQrActionState) {
            AppFunctions.showProfileQrCode(
              context: context,
              profileEntity: state.profileEntity,
              contacts: state.contacts,
            );
          } else if (state is ViewProfileContactShareActionState) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            await Share.share(state.shareText);
          } else if (state is ViewProfileNavigateToEditPageActionState) {
            context.read<AddProfileBloc>().add(AddProfileLoadEvent(task: "update"));
            context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());
            context.push('/profile/update');
          } else if (state is ViewProfileNavigateToHomePageActionState) {
            // refresh mini profile widget
            context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());
            context.pop();
          } else if (state is ViewProfileSnackBarActionState) {
            CustomSnackBarWidget.show(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ViewProfileInitial || state is ViewProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ViewProfileLoadedState) {
            ProfileEntity profileEntity = state.profileEntity;

            Map<String, dynamic> sharePlusData = {'name': profileEntity.name};

            if (state.contacts.isNotEmpty) {
              sharePlusData['country'] = state.contacts[0].country;
              sharePlusData['contact_number'] = state.contacts[0].number;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 16.0,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),

                        // profile picture
                        Column(
                          spacing: 18.0,
                          children: [
                            // profile picture
                            CircleAvatar(
                                radius: 80.0,
                                backgroundColor: colorScheme.surface,
                                backgroundImage: profileEntity.profilePicture!.isNotEmpty
                                    ? MemoryImage(profileEntity.profilePicture!)
                                    : AssetImage(AppConstants.defaultUserImage)),
                            Text(AppFunctions.getCapitalizedWords(profileEntity.name!), style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),

                        // contacts
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              color: colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                child: Column(
                                  children: [
                                    // empty case
                                    if (state.contacts.isEmpty)
                                      const ListTile(
                                        title: Opacity(
                                          opacity: 0.6,
                                          child: Text("No contact number found!"),
                                        ),
                                      ),

                                    ...state.contacts.map((contact) {
                                      ProfileContactEntity profileContactEntity = contact;

                                      return ListTile(
                                        leading: Icon(
                                          Icons.phone_outlined,
                                          color: AppConstants.callIconColor,
                                        ),
                                        title: Text("${AppFunctions.getCountryCode(profileContactEntity.country!)} ${profileContactEntity.number}"),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              color: colorScheme.surface,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.email_outlined,
                                        color: AppConstants.emailIconColor,
                                      ),
                                      title: Text(profileEntity.emailAddress != '' ? profileEntity.emailAddress! : '-'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: colorScheme.surface,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // contact qr code
                        Expanded(
                          child: InkWell(
                            onTap: () => context.read<ViewProfileBloc>().add(ViewProfileQrEvent(profileEntity: profileEntity, contacts: state.contacts)),
                            splashColor: colorScheme.surface,
                            highlightColor: colorScheme.surface,
                            child: const Column(
                              spacing: 6.0,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.qr_code),
                                Text("QR Code"),
                              ],
                            ),
                          ),
                        ),

                        // edit
                        Expanded(
                          child: InkWell(
                            onTap: () => context.read<ViewProfileBloc>().add(ViewProfileEditPageNavigateEvent()),
                            splashColor: colorScheme.surface,
                            highlightColor: colorScheme.surface,
                            child: const Column(
                              spacing: 6.0,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.edit),
                                Text("Update"),
                              ],
                            ),
                          ),
                        ),

                        // share
                        Expanded(
                          child: InkWell(
                            onTap: () => context.read<ViewProfileBloc>().add(ViewProfileContactShareEvent(data: sharePlusData)),
                            splashColor: colorScheme.surface,
                            highlightColor: colorScheme.surface,
                            child: const Column(
                              spacing: 6.0,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.share),
                                Text("Share"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else if (state is ViewProfileProfileNotFoundState) {
            return const Center(
              child: Text("Profile Not Found!"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
