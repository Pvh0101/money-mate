import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../presentation/widgets/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'monex',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingSlide(index);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(int index) {
    final List<Map<String, String>> slides = [
      {
        'image': 'assets/images/onboarding_1.png',
        'title': 'Note Down Expenses',
        'description': 'Daily note your expenses to help manage money',
      },
      {
        'image': 'assets/images/onboarding_2.png',
        'title': 'Simple Money Management',
        'description':
            'Get your notifications or alert when you do the over expenses',
      },
      {
        'image': 'assets/images/onboarding_3.png',
        'title': 'Easy to Track and Analize',
        'description':
            'Tracking your expense help make sure you don\'t overspend',
      },
    ];

    return _OnboardingSlide(
      key: ValueKey('onboarding_$index'),
      image: slides[index]['image']!,
      title: slides[index]['title']!,
      description: slides[index]['description']!,
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 20),
          CustomButton(
            text: 'LET\'S GO',
            onPressed: () {
              if (_currentPage < 2) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Routes.navigateToReplacement(context, RouteConstants.login);
              }
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: const Color(0xFF246BFD),
        dotColor: Colors.grey.shade300,
        dotHeight: 8,
        dotWidth: 8,
        spacing: 8,
        expansionFactor: 4,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: Image.asset(
              image,
              height: 226,
              width: 251,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
