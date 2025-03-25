import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/profile/presentation/blocs/view_profile/view_profile_bloc.dart';
import 'package:linklocker/features/profile/presentation/pages/add_profile_form_page.dart';

import '../../../../shared/widgets/custom_snackbar_widget.dart';
import '../blocs/add_profile/add_profile_bloc.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key, this.task = "add"});

  final String task;

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == "add" ? "Add Profile" : "Edit Profile"),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          highlightColor: Colors.transparent,
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              highlightColor: Colors.transparent,
              onPressed: () => context
                  .read<AddProfileBloc>()
                  .add(AddProfileLoadEvent(task: widget.task)),
              icon: Icon(Icons.undo_outlined),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AddProfileBloc, AddProfileState>(
        listenWhen: (previous, current) => current is AddProfileActionState,
        buildWhen: (previous, current) => current is! AddProfileActionState,
        listener: (context, state) {
          // snack bar
          if (state is AddProfileSnackBarActionState) {
            CustomSnackBarWidget.show(
              context: context,
              message: state.message,
            );
          } else if (state is AddProfileViewNavigateActionState) {
            context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());
            context.read<ViewProfileBloc>().add(ViewProfileFetchEvent());
            context.pop();
          } else if (state is AddProfileHomeNavigateActionState) {
            context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());
            context.pop();
          } else {}
        },
        builder: (context, state) {
          if (state is AddProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AddProfileLoadedState) {
            return AddProfileFormPage(
              task: widget.task,
              profileEntity: state.profileEntity,
              profileContactEntity: state.profileContactEntity,
            );
          } else if (state is AddProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddProfileAddedState) {
            return const Center(child: Text("Profile Already Added"));
          } else {
            return Center(child: Text(state.runtimeType.toString()));
          }
        },
      ),
    );
  }
}
