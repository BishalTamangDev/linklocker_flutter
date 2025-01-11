import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/presentation/home/home_page.dart';
import 'package:linklocker/features/presentation/link/add/add_link_page.dart';
import 'package:linklocker/features/presentation/link/view/view_link_page.dart';
import 'package:linklocker/features/presentation/page_not_found_page.dart';
import 'package:linklocker/features/presentation/profile/add_profile_page.dart';
import 'package:linklocker/features/presentation/profile/view_profile_page.dart';
import 'package:linklocker/features/presentation/search/search_page.dart';

class AppRoute {
  static final GoRouter routes = GoRouter(
    initialLocation: '/home',

    // routes
    routes: [
      // home
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HomePage(),
          transitionsBuilder: immediateTransitionBuilder,
        ),
      ),

      // profile
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ViewProfilePage(),
          transitionsBuilder: immediateTransitionBuilder,
        ),
        routes: [
          GoRoute(
            path: '/view',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ViewProfilePage(),
              transitionsBuilder: immediateTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(task: 'add'),
              transitionsBuilder: slideUpTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(task: 'edit'),
              transitionsBuilder: slideUpTransitionBuilder,
            ),
          ),
        ],
      ),

      // link
      GoRoute(
        path: '/link',
        builder: (context, state) => PageNotFoundPage(),
        routes: [
          GoRoute(
            path: '/view',
            pageBuilder: (context, state) {
              final Map<String, dynamic> link =
                  state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: ViewLinkPage(
                  link: link,
                ),
                transitionsBuilder: immediateTransitionBuilder,
              );
            },
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AddLinkPage(),
              transitionsBuilder: immediateTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) {
              var linkData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddLinkPage(task: "edit", data: linkData),
                transitionsBuilder: immediateTransitionBuilder,
              );
            },
          ),
        ],
      ),

      // search
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: SearchPage(),
          transitionsBuilder: slideLeftTransitionBuilder,
        ),
      ),
    ],

    // error page
    errorBuilder: (context, state) => PageNotFoundPage(),
  );
}

Widget immediateTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

Widget slideLeftTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

Widget slideUpTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}
