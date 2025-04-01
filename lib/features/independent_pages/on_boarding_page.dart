import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/shared/scroll_behaviour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  // variable
  int index = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to LinkLocker',
      'description': 'Your go-to app for managing contacts with links, QR codes and more. Easily add and share contacts, and search for them quickly',
      'image': 'welcome.svg',
      'type': 'svg',
    },
    {
      'title': 'Add and Manage Profiles',
      'description': 'Add profiles with links, and store contacts with ease. Quick access to your most important contacts!',
      'image': 'profile.svg',
      'type': 'svg',
    },
    {
      'title': 'Share & Add Contacts with QR Codes',
      'description': "Effortlessly share contacts using QR codes, and even scan others' QR codes to add them instantly.",
      'image': 'qr.png',
      'type': 'png',
    },
    {
      'title': 'Quickly Search Contacts',
      'description': 'Search for your contacts by name or number in no time. Stay organized and never lose track of important details.',
      'image': 'search.svg',
      'type': 'svg',
    },
    {
      'title': 'Use Phone Dialer',
      'description': 'Quickly dial numbers directly from the app with ease.',
      'image': 'dial-pad.png',
      'type': 'png',
    },
  ];

  // functions
  void _nextPage() {
    if (index < _pages.length) {
      setState(() {
        index++;
      });
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  // skip
  void _skip() {
    setState(() {
      index = _pages.length - 1;
    });
    _pageController.jumpToPage(_pages.length - 1);
  }

  // set initial value
  _setInitialValue() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboard_screen_shown', true);
    if (!mounted) return;
    context.pushReplacement('/home');
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: PageView(
            controller: _pageController,
            allowImplicitScrolling: false,
            onPageChanged: (newIndex) => setState(() {
              index = newIndex;
            }),
            children: _pages
                .map((page) => PageBuilder(
                      title: page['title'],
                      description: page['description'],
                      image: page['image'],
                      type: page['type'],
                    ))
                .toList(),
          ),
        ),
      ),
      // bottom section
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: index == _pages.length - 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _setInitialValue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text("Get Started"),
                  ),
                ],
              )
            : Row(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _skip,
                      child: const Text("Skip"),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _pages.length,
                          effect: WormEffect(
                            activeDotColor: Theme.of(context).colorScheme.primary,
                            dotWidth: 12.0,
                            dotHeight: 12.0,
                            dotColor: Theme.of(context).colorScheme.surface,
                          ),
                          onDotClicked: (newIndex) => _pageController.animateToPage(
                            newIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
      ),
    );
  }
}

class PageBuilder extends StatelessWidget {
  const PageBuilder({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
  });

  final String title;
  final String description;
  final String image;
  final String type;

  @override
  Widget build(BuildContext context) {
    String fullPath = type == 'png' ? 'assets/images/$image' : 'assets/svg/$image';

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(type == 'png' ? 64.0 : 32.0),
              child: type == 'png' ? Image.asset(fullPath) : SvgPicture.asset(fullPath),
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Opacity(
            opacity: 0.6,
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64.0),
        ],
      ),
    );
  }
}
