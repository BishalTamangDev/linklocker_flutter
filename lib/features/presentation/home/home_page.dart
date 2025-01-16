import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/custom_drawer_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/empty_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/fetching_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/link_widget.dart';
import 'package:linklocker/features/presentation/profile/profile_card/loading_profile_card_widget.dart';
import 'package:linklocker/features/presentation/profile/profile_card/profile_card_error_widget.dart';

import '../../../core/constants/app_functions.dart';
import '../profile/profile_card/profile_card_not_set_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // variables
  bool developerMode = false;
  bool hide = false;
  var userModel = UserModel();
  var localDataSource = LocalDataSource.getInstance();

  // variables
  late Future<Map<String, dynamic>> _userData;

  // future data
  late Future<List<Map<String, dynamic>>> _linkList, _contactList;

  @override
  void initState() {
    super.initState();

    //   fetch link list
    _linkList = localDataSource.getGroupedLinks();
    _contactList = localDataSource.getAllContacts();

    //   fetch user data
    _userData = localDataSource.getUser();
    WidgetsBinding.instance.addObserver(this);
  }

  // functions
  _refreshUserData() async {
    setState(() {
      _userData = localDataSource.getUser();
    });
  }

  // refresh link list
  _refreshLinkList() {
    setState(() {
      _linkList = localDataSource.getGroupedLinks();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        hide = false;
        // _refreshUserData();
        _refreshLinkList();
      });
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      setState(() {
        hide = false;
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

                    // option header
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
                                    // scan qr code
                                    IconButton(
                                      onPressed: () => context
                                          .push('/qr_scanner/home')
                                          .then((_) => _refreshLinkList()),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.qr_code_scanner,
                                          size: 20.0),
                                    ),

                                    // search
                                    IconButton(
                                      onPressed: () =>
                                          context.push('/search').then(
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
                            // user profile card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: FutureBuilder(
                                  future: _userData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return ProfileCardErrorWidget(
                                          callback: () {
                                            _refreshUserData();
                                          },
                                        );
                                      } else {
                                        if (snapshot.data!['user_id'] == null) {
                                          return ProfileCardNotSetWidget(
                                            callback: () {
                                              context.push('/profile/add').then(
                                                  (_) => _refreshUserData());
                                            },
                                          );
                                        } else {
                                          var userData = snapshot.data!;

                                          userModel.setId =
                                              userData['user_id'] ?? 0;
                                          userModel.setName =
                                              userData['name'] ?? "Unknown";
                                          userModel.setEmail =
                                              userData['email'] ?? "";
                                          userModel.setProfilePicture =
                                              userData['profile_picture'];

                                          var profileData = {
                                            'user_id': userModel.getId,
                                            'name': userModel.getName,
                                            'email': userModel.getEmail,
                                            'profile_picture':
                                                userModel.getProfilePicture,
                                            'contacts': userData['contacts'],
                                          };

                                          var contact = userData['contacts'][0];

                                          Map<String, dynamic> qrData = {
                                            "name": AppFunctions
                                                    .getCapitalizedWords(
                                                        userModel.getName)
                                                .trim()
                                                .toUpperCase(),
                                            "email_address": userModel.getEmail
                                                .toString()
                                                .trim(),
                                            "contact": {
                                              "country": AppFunctions
                                                  .getCapitalizedWords(
                                                      contact['country']),
                                              "number": contact['contact']
                                                  .toString()
                                                  .trim(),
                                            },
                                          };

                                          developer.log("qr data :: $qrData");

                                          return Column(
                                            spacing: 12.0,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(),
                                              ListTile(
                                                leading: Hero(
                                                  tag: 'profile_picture',
                                                  child: CircleAvatar(
                                                    radius: 32.0,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    backgroundImage: profileData[
                                                                'profile_picture']
                                                            .isEmpty
                                                        ? AssetImage(AppConstants
                                                            .defaultUserImage)
                                                        : MemoryImage(profileData[
                                                            'profile_picture']),
                                                  ),
                                                ),
                                                title: Text(
                                                  AppFunctions
                                                      .getCapitalizedWords(
                                                          userData['name']),
                                                ),
                                                subtitle: Opacity(
                                                  opacity: 0.6,
                                                  child: Text(
                                                    "My Profile",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ),
                                                trailing: userData['user_id'] ==
                                                        null
                                                    ? null
                                                    : IconButton(
                                                        onPressed: () =>
                                                            AppFunctions
                                                                .showUserQrCode(
                                                                    context,
                                                                    qrData),
                                                        icon:
                                                            Icon(Icons.qr_code),
                                                      ),
                                                onTap: () {
                                                  if (userData['user_id'] ==
                                                      null) {
                                                    context
                                                        .push('/profile/add')
                                                        .then((_) async {
                                                      await _refreshUserData();
                                                    });
                                                  } else {
                                                    // view profile
                                                    context
                                                        .push('/profile/view',
                                                            extra: profileData)
                                                        .then((_) =>
                                                            _refreshUserData());
                                                  }
                                                },
                                              ),
                                              const SizedBox(),
                                            ],
                                          );
                                        }
                                      }
                                    } else {
                                      return LoadingProfileCardWidget();
                                    }
                                  },
                                ),
                              ),
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
                                      return Column(
                                        spacing: 16.0,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...snapshot.data!.map(
                                            (group) => Column(
                                              spacing: 12.0,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  child: Text(
                                                    group['title']
                                                        .toString()
                                                        .toUpperCase(),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  child: Container(
                                                    color: colorScheme.surface,
                                                    child: ListView.separated(
                                                      padding: EdgeInsets.zero,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              Divider(
                                                                  height: 1.0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          group['links'].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // final
                                                        var linkWidgetData = {
                                                          'link_id':
                                                              group['links']
                                                                      [index]
                                                                  ['link_id'],
                                                          'name': group['links']
                                                              [index]['name'],
                                                          'email':
                                                              group['links']
                                                                      [index]
                                                                  ['email'],
                                                          'contacts':
                                                              group['links']
                                                                      [index]
                                                                  ['contacts'],
                                                          'profile_picture': group[
                                                                      'links']
                                                                  [index][
                                                              'profile_picture'],
                                                        };

                                                        List<
                                                                Map<String,
                                                                    dynamic>>
                                                            contacts =
                                                            group['links']
                                                                    [index]
                                                                ['contacts'];

                                                        return LinkWidget(
                                                          linkWidgetData:
                                                              linkWidgetData,
                                                          navCallBack: () =>
                                                              context
                                                                  .push(
                                                                    '/link/view',
                                                                    extra: group[
                                                                            'links']
                                                                        [index],
                                                                  )
                                                                  .then(
                                                                    (val) =>
                                                                        _refreshLinkList(),
                                                                  ),
                                                          callCallBack: () {
                                                            // launch bottom sheet if link has only one contacts

                                                            if (contacts
                                                                    .length ==
                                                                1) {
                                                              AppFunctions
                                                                  .openDialer(
                                                                      "${AppFunctions.getCountryCode(contacts[0]['country'])} ${contacts[0]['contact']}");
                                                            } else {
                                                              AppFunctions.showCallBottomSheet(
                                                                  context,
                                                                  group['links']
                                                                          [
                                                                          index]
                                                                      [
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

                            // reset tables
                            !developerMode
                                ? SizedBox(
                                    height: 44.0,
                                  )
                                : Column(
                                    children: [
                                      Wrap(
                                        spacing: 10.0,
                                        // runSpacing: 10.0,
                                        children: [
                                          // refresh
                                          OutlinedButton(
                                            onPressed: () async {
                                              _refreshLinkList();
                                              _refreshUserData();
                                            },
                                            child: const Text("Refresh"),
                                          ),

                                          // reset user table
                                          OutlinedButton(
                                            onPressed: () async {
                                              bool response =
                                                  await localDataSource
                                                      .resetUserTable();

                                              if (response) {
                                                _refreshUserData();
                                              }
                                            },
                                            child:
                                                const Text("Reset User Table"),
                                          ),

                                          // reset link table
                                          OutlinedButton(
                                            onPressed: () async {
                                              await localDataSource
                                                  .resetLinkTable();

                                              if (mounted) {
                                                _refreshLinkList();
                                              }
                                            },
                                            child:
                                                const Text("Reset Link Table"),
                                          ),

                                          // reset contact table
                                          OutlinedButton(
                                            onPressed: () async {
                                              await localDataSource
                                                  .resetContactTable();
                                            },
                                            child: const Text(
                                                "Reset Contact Table"),
                                          ),

                                          //   reset database
                                          OutlinedButton(
                                            onPressed: () async {
                                              await localDataSource.resetDb();
                                              _refreshUserData();
                                              _refreshLinkList();
                                            },
                                            child: const Text("Reset Database"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 54.0),
                                    ],
                                  ),
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
