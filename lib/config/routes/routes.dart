import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/pages/home/home_page.dart';
import 'package:linklocker/pages/link/add/add_link_page.dart';
import 'package:linklocker/pages/link/view/view_link_page.dart';
import 'package:linklocker/pages/page_not_found_page.dart';
import 'package:linklocker/pages/profile/add_profile_page.dart';
import 'package:linklocker/pages/profile/view_profile_page.dart';
import 'package:linklocker/pages/qr_scanner/qr_scanner_home_page.dart';
import 'package:linklocker/pages/qr_scanner/qr_scanner_result_page.dart';
import 'package:linklocker/pages/search/search_page.dart';

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
              );
            },
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
            pageBuilder: (context, state) {
              var profileData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddProfilePage(task: 'edit', profileData: profileData),
                transitionsBuilder: slideUpTransitionBuilder,
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
              );
            },
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AddLinkPage(),
              transitionsBuilder: slideLeftTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) {
              var linkData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddLinkPage(task: "edit", data: linkData),
                transitionsBuilder: slideLeftTransitionBuilder,
              );
            },
          ),
          GoRoute(
            path: '/qr_add',
            pageBuilder: (context, state) {
              var qrData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: AddLinkPage(
                  task: "qr_add",
                  dataSecond: qrData,
                ),
                transitionsBuilder: slideLeftTransitionBuilder,
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
            transitionsBuilder: slideLeftTransitionBuilder,
          );
        },
      ),

      //   qr scanner
      GoRoute(
        path: '/qr_scanner',
        builder: (context, state) => PageNotFoundPage(),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: QrScannerHomePage(),
                transitionsBuilder: slideLeftTransitionBuilder,
              );
            },
          ),
          GoRoute(
            path: '/result',
            pageBuilder: (context, state) {
              var qrData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                child: QrScannerResultPage(qrData: qrData),
                transitionsBuilder: slideLeftTransitionBuilder,
              );
            },
          ),
        ],
      ),

      //   setting
      GoRoute(
        path: '/setting',
        builder: (context, index) => PageNotFoundPage(),
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
