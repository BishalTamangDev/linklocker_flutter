import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/link/presentation/widgets/add_link_form_widget.dart';
import 'package:linklocker/shared/widgets/custom_snackbar_widget.dart';

import '../../../metric/presentation/blocs/metric_bloc.dart';
import '../blocs/all_links/all_links_bloc.dart';
import '../blocs/link_add/link_add_bloc.dart';
import '../blocs/link_view/link_view_bloc.dart';
// import '../blocs/link_view/link_view_bloc.dart';

class AddLinkPage extends StatefulWidget {
  const AddLinkPage({
    super.key,
    this.task = "add",
  });

  final String task;

  @override
  State<AddLinkPage> createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<AddLinkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
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
                if (widget.task == "update" || widget.task == "qr_add") {
                  context.read<LinkAddBloc>().add(LinkAddBackupEvent());
                } else {
                  context.read<LinkAddBloc>().add(LinkAddResetEvent());
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.undo),
            ),
          ),
        ],
        title: Text(
          widget.task == "add"
              ? "Add Link"
              : widget.task == "update"
                  ? "Update Link"
                  : "Adding from Qr Scan",
        ),
      ),
      body: BlocConsumer<LinkAddBloc, LinkAddState>(
        listenWhen: (previous, current) => current is LinkAddActionState,
        buildWhen: (previous, current) => current is! LinkAddActionState,
        listener: (context, state) {
          if (state is LinkAddAddedActionState) {
            CustomSnackBarWidget.show(context: context, message: "Link added successfully.");

            // refresh all links
            context.read<AllLinksBloc>().add(AllLinksFetchEvent());

            // refresh metric
            context.read<MetricBloc>().add(MetricFetchEvent());
          } else if (state is LinkAddAddingErrorActionState) {
            CustomSnackBarWidget.show(context: context, message: state.message);
          } else if (state is LinkAddUpdatedActionState) {
            // refresh all links
            context.read<AllLinksBloc>().add(AllLinksFetchEvent());

            // refresh metric
            context.read<MetricBloc>().add(MetricFetchEvent());

            CustomSnackBarWidget.show(context: context, message: "Link updated successfully.");
            context.read<LinkViewBloc>().add(FetchEvent(linkId: state.linkId));
            context.pop();
          } else if (state is LinkAddUpdatingErrorActionState) {
            CustomSnackBarWidget.show(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is LinkAddLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (state is LinkAddLoadedState) {
              return AddLinkFormWidget(
                task: widget.task,
                linkEntity: state.linkEntity,
                contacts: state.contacts,
              );
            }
            return Center(child: Text("State : $state"));
          }
        },
      ),
    );
  }
}
