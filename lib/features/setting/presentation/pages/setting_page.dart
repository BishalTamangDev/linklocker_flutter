import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/link/presentation/blocs/all_links/all_links_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/setting/presentation/blocs/setting_bloc.dart';
import 'package:linklocker/features/setting/presentation/widgets/setting_option_widget.dart';
import 'package:linklocker/shared/widgets/custom_alert_dialog_widget.dart';
import 'package:linklocker/shared/widgets/custom_snackbar_widget.dart';

class SettingHomePage extends StatefulWidget {
  const SettingHomePage({super.key});

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  // delete profile
  void _resetProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialogWidget(
          title: "Reset Profile",
          description: "Are you sure you want to reset your profile?",
          option1: 'Yes',
          option2: 'No',
          option1CallBack: () {
            context.read<SettingBloc>().add(SettingResetProfileEvent());
            context.pop();
          },
          option2CallBack: () => context.pop(),
        );
      },
    );
  }

  // delete links
  void _resetLink() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialogWidget(
          title: "Reset Links",
          description: "Are you sure you want to reset all your link?",
          option1: 'Yes',
          option2: 'No',
          option1CallBack: () {
            context.read<SettingBloc>().add(SettingResetLinkEvent());
            context.pop();
          },
          option2CallBack: () => context.pop(),
        );
      },
    );
  }

  // delete everything
  void _resetEverything() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialogWidget(
          title: "Reset Everything",
          description: "Are you sure you want to reset your profile and links?",
          option1: 'Yes',
          option2: 'No',
          option1CallBack: () {
            context.read<SettingBloc>().add(SettingResetEverythingEvent());
            context.pop();
          },
          option2CallBack: () => context.pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Setting"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<SettingBloc, SettingState>(
              listener: (context, state) {
                if (state is SettingResetProfileActionState) {
                  CustomSnackBarWidget.show(
                    context: context,
                    message: state.response ? "Profile reset successfully." : "Couldn't reset profile.",
                  );
                  // refresh mini profile
                  context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());
                } else if (state is SettingResetLinkActionState) {
                  CustomSnackBarWidget.show(
                    context: context,
                    message: state.response ? "Links reset successfully." : "Couldn't reset links.",
                  );
                  // reset view all link
                  context.read<AllLinksBloc>().add(AllLinksFetchEvent());
                } else if (state is SettingResetEverythingActionState) {
                  CustomSnackBarWidget.show(
                    context: context,
                    message: state.response ? "Profile & links reset successfully." : "Couldn't reset profile & links.",
                  );

                  // refresh mini profile
                  context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());

                  // reset view all link
                  context.read<AllLinksBloc>().add(AllLinksFetchEvent());
                }
              },
              child: SizedBox.shrink(),
            ),
            SettingOptionWidget(
              title: "Reset Profile",
              description: "Your account will be deleted but links wont be deleted.",
              trailingIcon: Icons.person_remove_alt_1_outlined,
              callback: _resetProfile,
            ),
            SettingOptionWidget(
              title: "Reset Link",
              description: "Your all links will be deleted.",
              trailingIcon: Icons.contacts_outlined,
              callback: _resetLink,
            ),
            SettingOptionWidget(
              title: "Reset Everything",
              description: "Everything will be deleted including your profile and the links.",
              trailingIcon: Icons.settings,
              callback: _resetEverything,
            ),
          ],
        ),
      ),
    );
  }
}
