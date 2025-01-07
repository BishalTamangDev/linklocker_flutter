import 'package:go_router/go_router.dart';
import 'package:linklocker/features/presentation/page_not_found_page.dart';

GoRouter router = GoRouter(
  initialLocation: '/',

  // routes
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PageNotFoundPage(),
    ),
  ],

  // error page
  errorBuilder: (context, state) => PageNotFoundPage(),
);
