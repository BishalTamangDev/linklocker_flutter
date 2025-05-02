import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/color_constants.dart';
import 'package:linklocker/core/constants/string_constants.dart';
import 'package:linklocker/core/utils/call_pad_utils.dart';
import 'package:linklocker/core/utils/date_time_utils.dart';
import 'package:linklocker/core/utils/qr_utils.dart';
import 'package:linklocker/core/utils/string_utils.dart';
import 'package:linklocker/features/link/data/models/link_model.dart';
import 'package:linklocker/features/link/presentation/blocs/all_links/all_links_bloc.dart';
import 'package:linklocker/features/link/presentation/blocs/link_view/link_view_bloc.dart';
import 'package:linklocker/features/link/presentation/widgets/view_widgets/view_link_loading_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/view_widgets/view_link_not_found_widget.dart';
import 'package:linklocker/shared/widgets/custom_alert_dialog_widget.dart';
import 'package:linklocker/shared/widgets/custom_snackbar_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../metric/presentation/blocs/metric_bloc.dart';

class ViewLinkPage extends StatefulWidget {
  const ViewLinkPage({super.key});

  @override
  State<ViewLinkPage> createState() => _ViewLinkPageState();
}

class _ViewLinkPageState extends State<ViewLinkPage> {
  // functions
  void _deleteDialog(int linkId) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialogWidget(
          title: "Delete Link",
          description: "Are you sure you want to delete this link?",
          option1: "Yes",
          option2: "No",
          option1CallBack: () {
            context.read<LinkViewBloc>().add(DeleteLinkEvent(linkId));
            context.pop();
          },
          option2CallBack: () => context.pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<LinkViewBloc, LinkViewState>(
      listenWhen: (previous, current) => current is LinkViewActionState,
      buildWhen: (previous, current) => current is! LinkViewActionState,
      listener: (context, state) async {
        if (state is LinkViewQrShareActionState) {
          QrUtils.showQrCode(context: context, linkEntity: state.linkEntity, contacts: state.contacts);
        } else if (state is LinkViewContactShareActionState) {
          await Future.delayed(Duration.zero, () {
            Share.share(state.shareText, subject: "Contact Share");
          });
        } else if (state is LinkViewOpenDialerActionState) {
          CallPadUtils.openDialer(state.contact);
        } else if (state is LinkViewDeleteSuccessActionState) {
          // refresh all links
          context.read<AllLinksBloc>().add(AllLinksFetchEvent());

          // refresh metric
          context.read<MetricBloc>().add(MetricFetchEvent());

          CustomSnackBarWidget.show(context: context, message: "Link deleted successfully");
          context.pop();
        } else if (state is LinkViewDeletionFailureActionState) {
          CustomSnackBarWidget.show(context: context, message: "Link couldn't be deleted.");
        } else if (state is LinkViewNavigateToUpdateActionState) {
          context.push('/link/update/${state.linkId}');
        }
      },
      builder: (context, state) {
        switch (state) {
          case LinkViewLinkNotFoundState():
            return ViewLinkNotFoundWidget();
          case LinkViewLoadedState():
            final LinkModel linkModel = LinkModel.fromEntity(state.linkEntity);
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () => context.pop(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).canvasColor,
                title: const Text("Link Details"),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (state.linkEntity.linkId != null) {
                        _deleteDialog(state.linkEntity.linkId!);
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).canvasColor,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // profile picture
                      Center(
                        child: Column(
                          spacing: 18.0,
                          children: [
                            CircleAvatar(
                              radius: 80.0,
                              backgroundColor: colorScheme.surface,
                              foregroundImage:
                                  linkModel.profilePicture!.isNotEmpty ? MemoryImage(linkModel.profilePicture!) : AssetImage(StringConstants.defaultUserImage),
                            ),
                            Text(
                              linkModel.name != null && linkModel.name != '' ? StringUtils.getCapitalizedWords(linkModel.name!) : 'Unknown',
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(),

                      // contacts
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          color: colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              children: [
                                // empty contact
                                state.contacts.isEmpty
                                    ? const ListTile(
                                        leading: Icon(Icons.phone_outlined, color: Colors.green),
                                        title: Opacity(opacity: 0.5, child: Text("Contact Not Found")),
                                      )
                                    : const SizedBox.shrink(),

                                // more than one contact case
                                ...state.contacts.map(
                                  (contact) {
                                    final String code = StringUtils.getCountryCode(contact.country ?? StringConstants.defaultCountry);

                                    return ListTile(
                                      leading: Icon(Icons.phone_outlined, color: Colors.green),
                                      title: Text("$code ${contact.number}"),
                                      trailing: TextButton(
                                        onPressed: () => context.read<LinkViewBloc>().add(DialerEvent(linkEntity: state.linkEntity, contacts: state.contacts)),
                                        child: const Text("call Now"),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // email address
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          color: colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              leading: Icon(Icons.email_outlined, color: ColorConstants.emailIconColor),
                              title: Text(linkModel.emailAddress != '' && linkModel.emailAddress != null ? linkModel.emailAddress! : "-"),
                            ),
                          ),
                        ),
                      ),

                      // birthday
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          color: colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              leading: Icon(Icons.cake_outlined, color: ColorConstants.birthdayIconColor),
                              title: Text(
                                linkModel.dateOfBirth != null ? DateTimeUtils.getFormattedDate(DateTime.parse(linkModel.dateOfBirth!.toString())) : "-",
                              ),
                            ),
                          ),
                        ),
                      ),

                      // category
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          color: colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              leading: Icon(Icons.group_add_outlined, color: ColorConstants.categoryIconColor),
                              title: Text(StringUtils.getCapitalizedWord(linkModel.category!.label)),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              leading: Icon(Icons.note_alt_outlined, color: ColorConstants.noteIconColor),
                              title: Opacity(
                                opacity: 0.5,
                                child: Text(StringUtils.getCapitalizedWord(linkModel.note != '' && linkModel.note != null ? linkModel.note! : "-")),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // bottom actions
              bottomNavigationBar: Container(
                color: colorScheme.surface,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // contact qr code
                      InkWell(
                        onTap: () => context.read<LinkViewBloc>().add(QrShareEvent(linkEntity: state.linkEntity, contacts: state.contacts)),
                        splashColor: colorScheme.surface, // Custom splash color
                        highlightColor: colorScheme.surface,
                        child: const Column(
                          spacing: 6.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.qr_code),
                            Text("QR Code"),
                          ],
                        ),
                      ),

                      // edit
                      InkWell(
                        onTap: () => context.read<LinkViewBloc>().add(UpdateNavigateEvent(linkModel.linkId!)),
                        splashColor: colorScheme.surface,
                        highlightColor: colorScheme.surface,
                        child: const Column(
                          spacing: 6.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit),
                            Text("Update"),
                          ],
                        ),
                      ),

                      // share
                      InkWell(
                        onTap: () => context.read<LinkViewBloc>().add(ContactShareEvent(linkEntity: state.linkEntity, contacts: state.contacts)),
                        splashColor: colorScheme.surface,
                        highlightColor: colorScheme.surface,
                        child: const Column(
                          spacing: 6.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share),
                            Text("Share"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return ViewLinkLoadingWidget();
        }
      },
    );
  }
}
