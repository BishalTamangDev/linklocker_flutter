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
        pageBuilder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return CustomTransitionPage(
            child: ViewProfilePage(profileData: data),
            transitionsBuilder: immediateTransitionBuilder,
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
        routes: [
          GoRoute(
            path: '/view',
            pageBuilder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: ViewProfilePage(profileData: data),
                transitionsBuilder: immediateTransitionBuilder,
                reverseTransitionDuration: const Duration(milliseconds: 500),
                transitionDuration: const Duration(milliseconds: 500),
              );
            },
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(task: 'add'),
              transitionsBuilder: slideUpTransitionBuilder,
              reverseTransitionDuration: const Duration(milliseconds: 500),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) {
              var profileData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddProfilePage(task: 'edit', profileData: profileData),
                transitionsBuilder: slideUpTransitionBuilder,
                reverseTransitionDuration: const Duration(milliseconds: 500),
                transitionDuration: const Duration(milliseconds: 500),
              );
            },
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
                transitionsBuilder: slideLeftTransitionBuilder,
                reverseTransitionDuration: const Duration(milliseconds: 500),
                transitionDuration: const Duration(milliseconds: 500),
              );
            },
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AddLinkPage(),
              transitionsBuilder: slideLeftTransitionBuilder,
              reverseTransitionDuration: const Duration(milliseconds: 500),
              transitionDuration: const Duration(milliseconds: 500),
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) {
              var linkData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddLinkPage(task: "edit", data: linkData),
                transitionsBuilder: slideLeftTransitionBuilder,
                reverseTransitionDuration: const Duration(milliseconds: 500),
                transitionDuration: const Duration(milliseconds: 500),
              );
            },
          ),
        ],
      ),

      // search
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: SearchPage(),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: slideLeftTransitionBuilder,
          );
        },
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
