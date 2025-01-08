import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/custom_drawer_widget.dart';
import 'package:linklocker/features/presentation/home/widgets/user_profile_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // variables
  var localDataSource = LocalDataSource.getInstance();

  bool hide = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
                                      onPressed: () =>
                                          context.push('/link/add'),
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

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: const Text("Links"),
                            ),

                            // links
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Column(
                                children: [
                                  Container(
                                    color: colorScheme.surface,
                                    height: 0.0,
                                  ),
                                  ...List.generate(
                                    3,
                                    (index) {
                                      return Container(
                                        color: colorScheme.surface,
                                        child: ListTile(
                                          onTap: () =>
                                              context.push('/link/view/$index'),
                                          leading: CircleAvatar(
                                            radius: 24.0,
                                            backgroundColor:
                                                colorScheme.secondary,
                                            foregroundImage: AssetImage(
                                                'assets/images/blank_user.png'),
                                          ),
                                          title: Text(
                                              "Alexander Bose - ${index + 1}"),
                                          subtitle:
                                              const Text("someone@gmail.com"),
                                          trailing: IconButton(
                                            color: AppConstants.callIconColor,
                                            onPressed: () {
                                              developer.log("Call now");
                                              showCallBottomSheet();
                                            },
                                            icon: Icon(Icons.call),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    color: colorScheme.surface,
                                    height: 0.0,
                                  ),

                                  const SizedBox(height: 32.0),

                                  //   reset database
                                  ElevatedButton(
                                    onPressed: () async {
                                      await localDataSource.resetDb();
                                    },
                                    child: const Text("Reset Database"),
                                  ),
                                ],
                              ),
                            ),

                            Center(
                              child: Column(
                                spacing: 12.0,
                                children: const <Widget>[
                                  Icon(Icons.hourglass_empty_outlined),
                                  Text("No link found!"),
                                ],
                              ),
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
  showCallBottomSheet() {
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
                  ...List.generate(
                    2,
                    (index) => SizedBox(
                      child: ListTile(
                        title: Text("+977 ${(index + 1) * 785412}"),
                        trailing: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Call Now"),
                        ),
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
