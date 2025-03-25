import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/independent_pages/page_not_found_page.dart';
import 'package:linklocker/features/link/presentation/pages/add_link_page.dart';
import 'package:linklocker/features/link/presentation/pages/search_link_page.dart';
import 'package:linklocker/features/link/presentation/pages/view_all_links_page.dart';
import 'package:linklocker/features/link/presentation/pages/view_link_page.dart';
import 'package:linklocker/features/profile/presentation/pages/add_profile_page.dart';
import 'package:linklocker/features/profile/presentation/pages/view_profile_page.dart';
import 'package:linklocker/features/scanner/presentation/pages/qr_scanner_home_page.dart';
import 'package:linklocker/features/scanner/presentation/pages/qr_scanner_result_page.dart';
import 'package:linklocker/features/setting/presentation/pages/setting_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/links',

    // routes
    routes: [
      // home
      GoRoute(
        path: '/links',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ViewAllLinksPage(),
          transitionsBuilder: immediateTransitionBuilder,
        ),
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

      // profile
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              child: PageNotFoundPage(),
              transitionsBuilder: immediateTransitionBuilder);
        },
        routes: [
          GoRoute(
            path: '/view',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: ViewProfilePage(),
                transitionsBuilder: immediateTransitionBuilder,
              );
            },
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(
                task: 'add',
              ),
              transitionsBuilder: slideUpTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/edit',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(
                task: 'edit',
              ),
              transitionsBuilder: slideUpTransitionBuilder,
            ),
            // pageBuilder: (context, state) {
            //   var profileData = state.extra as Map<String, dynamic>;
            //   return CustomTransitionPage(
            //     child: AddProfilePage(
            //       task: 'edit',
            //       profileData: profileData,
            //       profileEntity: ProfileEntity(),
            //     ),
            //     transitionsBuilder: slideUpTransitionBuilder,
            //   );
            // },
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
        pageBuilder: (context, state) => CustomTransitionPage(
          child: SettingHomePage(),
          transitionsBuilder: slideLeftTransitionBuilder,
        ),
      ),
    ],

    // error page
    errorPageBuilder: (context, state) => CustomTransitionPage(
        transitionsBuilder: immediateTransitionBuilder,
        child: PageNotFoundPage()),
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
