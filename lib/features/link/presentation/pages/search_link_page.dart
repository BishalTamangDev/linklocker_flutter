import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/link/data/models/link_model.dart';
import 'package:linklocker/features/link/presentation/blocs/link_search/link_search_bloc.dart';
import 'package:linklocker/features/link/presentation/widgets/link_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/search_widgets/search_empty_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/search_widgets/search_error_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/search_widgets/search_initial_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/search_widgets/search_searching_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // variable
  Timer? _debounce;
  bool hasText = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchController,
          onChanged: (newValue) async {
            final searchText = newValue.toString().trim();
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () {
              setState(() {
                hasText = newValue.isNotEmpty ? true : false;
              });
              if (searchText.isEmpty) {
                context.read<LinkSearchBloc>().add(LinkSearchInitialEvent());
              } else {
                context.read<LinkSearchBloc>().add(LinkSearchSearchEvent(searchText: searchText.toString()));
              }
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search contact",
            suffixIcon: !hasText
                ? null
                : InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      context.read<LinkSearchBloc>().add(LinkSearchInitialEvent());
                      setState(() {
                        searchController.clear();
                        hasText = false;
                      });
                    },
                    child: const Icon(Icons.close),
                  ),
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.surface,
      ),

      backgroundColor: Theme.of(context).canvasColor,

      // body
      body: BlocConsumer<LinkSearchBloc, LinkSearchState>(
        listenWhen: (previous, current) => current is LinkSearchActionState,
        buildWhen: (previous, current) => current is! LinkSearchActionState,
        listener: (context, state) {
          debugPrint("Action state :: ${state.runtimeType}");
        },
        builder: (context, state) {
          if (state is LinkSearchInitial) {
            return SearchInitialWidget();
          } else if (state is LinkSearchSearchingState) {
            return SearchSearchingWidget();
          } else if (state is LinkSearchEmptyState) {
            return SearchEmptyWidget();
          } else if (state is LinkSearchErrorState) {
            return SearchErrorWidget();
          } else if (state is LinkSearchSearchedState) {
            final links = state.links;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: links.length,
              itemBuilder: (context, index) {
                final linkEntity = LinkModel.fromMap(links[index]['profile']).toEntity();
                final contacts = links[index]['contacts'];

                return LinkWidget(linkEntity: linkEntity, contacts: contacts);
              },
              separatorBuilder: (context, index) => Divider(height: 0),
            );
          } else {
            return Center(
              child: Text(state.toString()),
            );
          }
        },
      ),
    );
  }
}
