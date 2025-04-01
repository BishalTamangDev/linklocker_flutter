import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/functions/app_functions.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/widgets/mini_profile_widget_error.dart';
import 'package:linklocker/features/mini_profile/presentation/widgets/mini_profile_widget_loaded.dart';
import 'package:linklocker/features/mini_profile/presentation/widgets/mini_profile_widget_not_set.dart';

import '../../../profile/presentation/blocs/add_profile/add_profile_bloc.dart';
import 'mini_profile_widget_loading.dart';

class MiniProfileWidget extends StatefulWidget {
  const MiniProfileWidget({super.key});

  @override
  State<MiniProfileWidget> createState() => _MiniProfileWidgetState();
}

class _MiniProfileWidgetState extends State<MiniProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BlocConsumer<MiniProfileBloc, MiniProfileState>(
            listenWhen: (previous, current) => current is MiniProfileActionState,
            buildWhen: (previous, current) => current is! MiniProfileActionState,
            listener: (context, state) {
              if (state is MiniProfileAddNavigateState) {
                context.read<AddProfileBloc>().add(AddProfileLoadEvent(task: "add"));
                context.push('/profile/add');
              } else if (state is MiniProfileViewNavigateState) {
                context.push('/profile/view');
              } else if (state is MiniProfileQrShareState) {
                AppFunctions.showProfileQrCode(
                  context: context,
                  profileEntity: state.profileEntity,
                  contacts: state.contacts,
                );
              } else {}
            },
            builder: (context, state) {
              if (state is MiniProfileErrorState) {
                return MiniProfileWidgetError(callback: () {});
              } else if (state is MiniProfileLoadedState) {
                return MiniProfileWidgetLoaded(
                  profileEntity: state.profileEntity,
                  contacts: state.contacts,
                );
              } else if (state is MiniProfileNotSetState) {
                return MiniProfileWidgetNotSet();
              } else {
                // states :: MiniProfileInitial && MiniProfileLoadingState
                return MiniProfileWidgetLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
