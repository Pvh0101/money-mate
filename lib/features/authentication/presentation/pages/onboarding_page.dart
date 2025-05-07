import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/buttons/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'Note Down Expenses',
      'description': 'Daily note your expenses to\nhelp manage money',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'Simple Money Management',
      'description':
          'Get your notifications or alert\nwhen you do the over expenses',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'Easy to Track and Analize',
      'description':
          'Tracking your expense help make sure\nyou don\'t overspend',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final slide in _slides) {
        precacheImage(AssetImage(slide['image']!), context);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'monex',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                physics: const PageScrollPhysics(
                  parent: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast,
                  ),
                ),
                itemBuilder: (context, index) {
                  return RepaintBoundary(
                    key: ValueKey('onboarding_slide_$index'),
                    child: _buildOnboardingSlide(context, index),
                  );
                },
              ),
            ),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(BuildContext context, int index) {
    final slide = _slides[index];

    return _OnboardingSlide(
      key: ValueKey('onboarding_$index'),
      image: slide['image']!,
      title: slide['title']!,
      description: slide['description']!,
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPageIndicator(context),
          const SizedBox(height: 40),
          CustomButton(
            text: _currentPage == 2 ? "LET'S GO" : "NEXT",
            onPressed: () {
              if (_currentPage < 2) {
                _pageController.animateToPage(
                  _currentPage + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Routes.navigateToReplacement(context, RouteConstants.login);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SmoothPageIndicator(
      controller: _pageController,
      count: _slides.length,
      effect: ExpandingDotsEffect(
        activeDotColor: colorScheme.primary,
        dotColor: colorScheme.surfaceVariant,
        dotHeight: 8,
        dotWidth: 8,
        spacing: 8,
        expansionFactor: 3,
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const _OnboardingSlide({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 240,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
