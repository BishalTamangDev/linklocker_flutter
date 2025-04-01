import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/core/functions/app_functions.dart';
import 'package:linklocker/features/link/presentation/blocs/all_links/all_links_bloc.dart';
import 'package:linklocker/features/link/presentation/widgets/empty_links_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/fetching_links_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/link_widget.dart';

import '../../data/models/link_model.dart';

class AllLinksWidget extends StatelessWidget {
  const AllLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllLinksBloc, AllLinksState>(
      listenWhen: (previous, current) => current is AllLinksActionState,
      buildWhen: (previous, current) => current is! AllLinksActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AllLinksFetchedState) {
          final List<Map<String, dynamic>> groupedLinks = state.groupedLinks;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: groupedLinks.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // group
              final group = groupedLinks[index];
              final links = group['links'];

              return Column(
                spacing: 6.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(AppFunctions.getCapitalizedWord(group['title'])),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListView.separated(
                        itemCount: links.length!,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, state) => Divider(
                          height: 0,
                        ),
                        itemBuilder: (context, index) {
                          final linkEntity = LinkModel.fromMap(links[index]['profile']).toEntity();
                          final contacts = links[index]['contacts'];

                          // links
                          return LinkWidget(linkEntity: linkEntity, contacts: contacts);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                ],
              );
            },
          );
        } else if (state is AllLinksEmptyState) {
          return EmptyLinksWidget();
        } else {
          return FetchingLinksWidget();
        }
      },
    );
  }
}
