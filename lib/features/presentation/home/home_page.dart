import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/models/link_model.dart';
import 'package:linklocker/features/data/models/user_model.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/custom_drawer_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/empty_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/fetching_links_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/link_widget.dart';
import 'package:linklocker/features/presentation/profile/profile_card/loading_profile_card_widget.dart';
import 'package:linklocker/features/presentation/profile/profile_card/profile_card_error_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_functions.dart';
import '../profile/profile_card/profile_card_not_set_widget.dart';

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

  // variables
  late Future<Map<String, dynamic>> _userData;

  // future data
  late Future<List<Map<String, dynamic>>> _linkList;

  @override
  void initState() {
    super.initState();

    //   fetch link list
    _linkList = localDataSource.getLinks();

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
      _linkList = localDataSource.getLinks();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        hide = false;
        _refreshUserData();
        _refreshLinkList();
      });
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      developer.log("Resume to refresh!");
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
                                    IconButton(
                                      onPressed: () => context
                                          .push('/link/add')
                                          .then((_) => _refreshLinkList()),
                                      iconSize: 26.0,
                                      icon: Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () => context
                                          .push('/search')
                                          .then((_) => _refreshLinkList()),
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
                                              userData['name'] ?? "";
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

                                          var qrData = {
                                            'contacts': userData['contacts'],
                                            'email_address': userModel.getEmail,
                                            'name': userModel.getName,
                                          };

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
                                                        onPressed: () {
                                                          showUserQrCode(
                                                              qrData);
                                                        },
                                                        icon: Icon(Icons.share),
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

                                            linkModel.linkId = data['link_id'];
                                            linkModel.name = data['name'];
                                            linkModel.category =
                                                data['category'];
                                            linkModel.emailAddress =
                                                data['email'];
                                            linkModel.profilePicture =
                                                data['profile_picture'];

                                            var contacts = data['contacts'];

                                            return Container(
                                              color: colorScheme.surface,
                                              child: LinkWidget(
                                                linkWidgetData: {
                                                  'name': linkModel.name,
                                                  'email':
                                                      linkModel.emailAddress,
                                                  'contacts': contacts,
                                                  'profile_picture':
                                                      linkModel.profilePicture,
                                                },
                                                navCallBack: () => context
                                                    .push(
                                                      '/link/view',
                                                      extra: data,
                                                    )
                                                    .then((_) =>
                                                        _refreshLinkList()),
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

                            // reset tables
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
                                        await localDataSource.resetUserTable();

                                    if (response) {
                                      _refreshUserData();
                                    }
                                  },
                                  child: const Text("Reset User Table"),
                                ),

                                // reset link table
                                OutlinedButton(
                                  onPressed: () async {
                                    await localDataSource.resetLinkTable();

                                    if (mounted) {
                                      _refreshLinkList();
                                    }
                                  },
                                  child: const Text("Reset Link Table"),
                                ),

                                // reset contact table
                                OutlinedButton(
                                  onPressed: () async {
                                    await localDataSource.resetContactTable();
                                  },
                                  child: const Text("Reset Contact Table"),
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

  // user qr code
  void showUserQrCode(Map<String, dynamic> qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppFunctions.getCapitalizedWords(qrData['name'])),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: QrImageView(
                  data: qrData.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: const Text("Scan the QR code to add this contact."),
            ),
          ],
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
