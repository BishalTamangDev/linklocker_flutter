import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/data/models/user_model.dart';
import 'package:linklocker/data/source/local/local_data_source.dart';
import 'package:linklocker/features/link/presentation/widgets/chart_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/empty_links_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/fetching_links_widget.dart';
import 'package:linklocker/features/link/presentation/widgets/link_widget.dart';
import 'package:linklocker/features/mini_profile/presentation/widgets/mini_profile_widget.dart';

import '../../../../../core/constants/app_functions.dart';

class ViewAllLinksPage extends StatefulWidget {
  const ViewAllLinksPage({super.key});

  @override
  State<ViewAllLinksPage> createState() => _ViewAllLinksPageState();
}

class _ViewAllLinksPageState extends State<ViewAllLinksPage> {
  // variables
  var userModel = UserModel();

  // future data
  late Future<List<Map<String, dynamic>>> _linkList;

  @override
  void initState() {
    _linkList = LocalDataSource.getInstance().getGroupedLinks();
    super.initState();
  }

  // functions
  _refreshUserData() async {
    setState(() {});
  }

  // refresh link list
  _refreshLinkList() {
    setState(() {
      _linkList = LocalDataSource.getInstance().getGroupedLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 0,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 64.0,
              left: 32.0,
              right: 32.0,
              bottom: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 64.0,
              children: [
                ChartWidget(),

                //   setting
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                      context.push('/setting').then((_) {
                        _refreshUserData();
                        _refreshLinkList();
                      });
                    },
                    child: const Text("Setting"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              // app bar
              SliverAppBar(
                shadowColor: Colors.transparent,
                elevation: 4,
                pinned: false,
                floating: true,
                expandedHeight: 200,
                centerTitle: false,
                snap: true,
                scrolledUnderElevation: 0.0,
                backgroundColor: Theme.of(context).canvasColor,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "LinkLocker",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'patrickhand',
                    ),
                  ),
                  centerTitle: true,
                  collapseMode: CollapseMode.none,
                ),
              ),

              // Sticky header using SliverPersistentHeader
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyPaddingHeaderDelegate(
                  height: MediaQuery.of(context).padding.top,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),

              // option header
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Icon(Icons.menu),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // scan qr code
                              IconButton(
                                onPressed: () => context
                                    .push('/qr_scanner/home')
                                    .then((_) => _refreshLinkList()),
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.qr_code_scanner, size: 20.0),
                              ),

                              // search
                              IconButton(
                                onPressed: () => context.push('/search').then(
                                      (_) => _refreshLinkList(),
                                    ),
                                icon: Icon(Icons.search_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // main content container
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    spacing: 16.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // mini profile widget
                      MiniProfileWidget(),

                      // link lists :: actual
                      FutureBuilder(
                        future: _linkList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return FetchingLinksWidget();
                            } else {
                              if (snapshot.data!.isEmpty) {
                                return EmptyLinksWidget();
                              } else {
                                return Column(
                                  spacing: 16.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...snapshot.data!.map(
                                      (group) => Column(
                                        spacing: 12.0,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(
                                              group['title']
                                                  .toString()
                                                  .toUpperCase(),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        Divider(height: 1.0),
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    group['links'].length,
                                                itemBuilder: (context, index) {
                                                  // final
                                                  var linkWidgetData = {
                                                    'link_id': group['links']
                                                        [index]['link_id'],
                                                    'name': group['links']
                                                        [index]['name'],
                                                    'email': group['links']
                                                        [index]['email'],
                                                    'contacts': group['links']
                                                        [index]['contacts'],
                                                    'profile_picture':
                                                        group['links'][index]
                                                            ['profile_picture'],
                                                  };

                                                  List<Map<String, dynamic>>
                                                      contacts = group['links']
                                                          [index]['contacts'];

                                                  return LinkWidget(
                                                    linkWidgetData:
                                                        linkWidgetData,
                                                    navCallBack: () => context
                                                        .push(
                                                          '/link/view',
                                                          extra: group['links']
                                                              [index],
                                                        )
                                                        .then(
                                                          (val) =>
                                                              _refreshLinkList(),
                                                        ),
                                                    callCallBack: () {
                                                      // launch bottom sheet if link has only one contacts

                                                      if (contacts.length ==
                                                          1) {
                                                        AppFunctions.openDialer(
                                                            "${AppFunctions.getCountryCode(contacts[0]['country'])} ${contacts[0]['contact']}");
                                                      } else {
                                                        AppFunctions
                                                            .showCallBottomSheet(
                                                                context,
                                                                group['links']
                                                                        [index][
                                                                    'contacts']);
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                  ],
                                );
                              }
                            }
                          } else {
                            return FetchingLinksWidget();
                          }
                        },
                      ),

                      const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/link/add').then(
              (_) => _refreshLinkList(),
            ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

// fixed blank header
class _StickyPaddingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyPaddingHeaderDelegate({required this.child, required this.height});

  final double height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => height; // Maximum height of the header
  @override
  double get minExtent => height; // Minimum height of the header
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Rebuild if the header changes
  }
}

// fixed header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 60.0; // Maximum height of the header
  @override
  double get minExtent => 60.0; // Minimum height of the header
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Rebuild if the header changes
  }
}
