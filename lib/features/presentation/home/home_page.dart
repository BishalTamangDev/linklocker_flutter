import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/data/models/contact_model.dart';
import 'package:linklocker/features/data/models/link_model.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/custom_drawer_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/empty_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/fetching_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/link_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/user_profile_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // variables
  bool hide = false;
  var userModel = UserModel();
  var localDataSource = LocalDataSource.getInstance();

  // future data
  late Future<List<Map<dynamic, dynamic>>> _linkList;
  late Future<List<Map<dynamic, dynamic>>> _contactLists;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //   fetch link list
    _linkList = localDataSource.getLinks();

    //   fetch all contacts
    _contactLists = localDataSource.getAllContacts();
  }

  // refresh link list
  _refreshLinkList() {
    setState(() {
      _linkList = localDataSource.getLinks();
    });
    _refreshContactLists();
  }

  // refresh contact list
  _refreshContactLists() {
    setState(() {
      _contactLists = localDataSource.getAllContacts();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        hide = false;
      });
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      setState(() {
        hide = true;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return hide
        ? Scaffold(
            backgroundColor: themeContext.canvasColor,
            body: Center(
              child: Column(
                spacing: 16.0,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("👋", style: textTheme.headlineLarge),
                  const Text("See you again!"),
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: CustomDrawerWidget(),
            backgroundColor: themeContext.canvasColor,
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
                        height: mediaQuery.padding.top,
                        child: Container(
                          color: themeContext.canvasColor,
                        ),
                      ),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyHeaderDelegate(
                        child: Container(
                          color: themeContext.canvasColor,
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
                                  onTap: () =>
                                      Scaffold.of(context).openDrawer(),
                                  child: Icon(Icons.menu),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => context
                                          .push('/link/add')
                                          .then((_) => _refreshLinkList()),
                                      iconSize: 26.0,
                                      icon: Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () => context.push('/search'),
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

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          spacing: 16.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // user profile card
                            UserProfileCard(),

                            //   reset database
                            ElevatedButton(
                              onPressed: () async {
                                await localDataSource.resetDb();
                              },
                              child: const Text("Reset Database"),
                            ),

                            Opacity(
                              opacity: 0.5,
                              child: Text("RESET TABLE"),
                            ),

                            // reset tables
                            Wrap(
                              spacing: 10.0,
                              // runSpacing: 10.0,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    _refreshLinkList();
                                  },
                                  child: const Text("Refresh"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await localDataSource.resetUserTable();
                                  },
                                  child: const Text("User Table"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await localDataSource.resetLinkTable();

                                    if (context.mounted) {
                                      _refreshLinkList();
                                    }
                                  },
                                  child: const Text("Reset Link Table"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await localDataSource.resetContactTable();
                                    _refreshContactLists();
                                  },
                                  child: const Text("Reset Contact Table"),
                                ),
                              ],
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: const Text("Links"),
                            ),

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
                                      developer
                                          .log("All data :: ${snapshot.data}");
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              Divider(height: 1.0),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            // map data
                                            var data = snapshot.data![index];

                                            var linkModel = LinkModel();
                                            var contactModel = ContactModel();

                                            linkModel.linkId = data['link_id'];
                                            linkModel.name = data['name'];
                                            linkModel.category =
                                                data['category'];
                                            linkModel.emailAddress =
                                                data['email'];

                                            var contacts = data['contacts'];

                                            return Container(
                                              color: colorScheme.surface,
                                              child: LinkWidget(
                                                linkWidgetData: {
                                                  'name': linkModel.name,
                                                  'email':
                                                      linkModel.emailAddress,
                                                },
                                                navCallBack: () => context.push(
                                                    '/link/view/${linkModel.linkId}'),
                                                callCallBack: () =>
                                                    showCallBottomSheet(
                                                        contacts),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  }
                                } else {
                                  return FetchingLinksWidget();
                                }
                              },
                            ),

                            const SizedBox(),

                            // temporary :: contacts
                            FutureBuilder(
                              future: _contactLists,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        "Couldn't fetch contacts. Error :: ${snapshot.error}");
                                  } else {
                                    return Text("${snapshot.data}");
                                  }
                                } else {
                                  return CircularProgressIndicator();
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
          );
  }

  // bottom sheet call
  showCallBottomSheet(List<Map<String, dynamic>> contacts) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: mediaQuery.size.height / 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 1.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...contacts.map(
                    (contact) => ListTile(
                      title: Text(contact['contact']),
                      trailing: OutlinedButton(
                        onPressed: () {},
                        child: const Text("Call Now"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
