import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/features/home/presentation/pages/home_page.dart';
import 'package:linklocker/features/independent_pages/page_not_found_page.dart';
import 'package:linklocker/features/link/presentation/blocs/link_add/link_add_bloc.dart';
import 'package:linklocker/features/link/presentation/pages/add_link_page.dart';
import 'package:linklocker/features/link/presentation/pages/search_link_page.dart';
import 'package:linklocker/features/link/presentation/pages/view_link_page.dart';
import 'package:linklocker/features/profile/presentation/pages/add_profile_page.dart';
import 'package:linklocker/features/profile/presentation/pages/view_profile_page.dart';
import 'package:linklocker/features/setting/presentation/pages/setting_page.dart';

import '../../features/link/presentation/blocs/link_view/link_view_bloc.dart';
import '../../features/qr_add/presentation/pages/qr_add_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
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
      // link
      GoRoute(
        path: '/link',
        builder: (context, state) => PageNotFoundPage(),
        routes: [
          GoRoute(
            path: '/view/:id',
            pageBuilder: (context, state) {
              final int id = int.parse(state.pathParameters['id'] ?? '0');
              context.read<LinkViewBloc>().add(FetchEvent(linkId: id));
              return CustomTransitionPage(
                child: ViewLinkPage(),
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
            path: '/qr_add',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: AddLinkPage(task: "qr_add"),
                transitionsBuilder: slideLeftTransitionBuilder,
              );
            },
          ),
          GoRoute(
            path: '/update/:linkId',
            pageBuilder: (context, state) {
              final int linkId = int.parse(state.pathParameters['linkId']!);

              context.read<LinkAddBloc>().add(LinkLoadEvent(task: 'update', linkId: linkId));

              return CustomTransitionPage(
                child: const AddLinkPage(task: "update"),
                transitionsBuilder: immediateTransitionBuilder,
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
            transitionsBuilder: immediateTransitionBuilder,
          );
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
              child: AddProfilePage(task: 'add'),
              transitionsBuilder: immediateTransitionBuilder,
            ),
          ),
          GoRoute(
            path: '/update',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: AddProfilePage(task: 'update'),
              transitionsBuilder: immediateTransitionBuilder,
            ),
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
                child: QrAddPage(),
                transitionsBuilder: slideLeftTransitionBuilder,
              );
            },
          ),
        ],
      ),

      // setting
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
      child: PageNotFoundPage(),
    ),
  );
}

Widget immediateTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween(begin: Offset.zero, end: Offset.zero).animate(animation),
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
    position: Tween(begin: Offset(1, 0), end: Offset.zero).animate(animation),
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
    position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(animation),
    child: child,
  );
}
