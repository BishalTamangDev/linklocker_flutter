import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/home/presentation/widgets/drawer_widget.dart';
import 'package:linklocker/features/link/presentation/blocs/link_add/link_add_bloc.dart';
import 'package:linklocker/features/link/presentation/blocs/link_search/link_search_bloc.dart';
import 'package:linklocker/features/link/presentation/widgets/all_links_widget.dart';
import 'package:linklocker/features/metric/presentation/blocs/metric_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/widgets/mini_profile_widget.dart';

import '../../../link/presentation/blocs/all_links/all_links_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
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
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
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
                              Visibility(
                                visible: false,
                                child: IconButton(
                                  onPressed: () {
                                    // refresh mini profile
                                    context.read<MiniProfileBloc>().add(MiniProfileFetchEvent());

                                    // refresh all links
                                    context.read<AllLinksBloc>().add(AllLinksFetchEvent());

                                    // refresh metric
                                    context.read<MetricBloc>().add(MetricFetchEvent());

                                    // refresh search page
                                    context.read<LinkSearchBloc>().add(LinkSearchInitialEvent());
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                              ),

                              // scan qr code
                              IconButton(
                                onPressed: () => context.push('/qr_scanner/home'),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.qr_code_scanner, size: 20.0),
                              ),

                              // search
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () => context.push('/search'),
                                icon: const Icon(Icons.search_outlined),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // mini profile widget
                      MiniProfileWidget(),

                      // link lists
                      AllLinksWidget(),

                      const SizedBox(height: 80.0),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<LinkAddBloc>().add(LinkLoadEvent(task: 'add', linkId: 0));
          context.push('/link/add');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

// fixed header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
