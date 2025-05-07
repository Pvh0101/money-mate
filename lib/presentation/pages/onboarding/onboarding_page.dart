import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../presentation/widgets/custom_button.dart';
// import 'package:google_fonts/google_fonts.dart'; // GoogleFonts sẽ được lấy từ TextTheme

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
    final theme = Theme.of(context); // Lấy theme
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.background, // Thường thì Scaffold tự lấy màu này
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
                    style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold), // Cập nhật style
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
                  return _buildOnboardingSlide(context, index); // Truyền context
                },
              ),
            ),
            _buildBottomSection(context), // Truyền context
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(BuildContext context, int index) { // Nhận context
    final List<Map<String, String>> slides = [
      {
        'image': 'assets/images/onboarding_slide_1_illustration.svg',
        'title': 'Note Down Expenses',
        'description': 'Daily note your expenses to\nhelp manage money',
      },
      {
        'image': 'assets/images/onboarding_slide_2_illustration.svg',
        'title': 'Simple Money Management',
        'description':
            'Get your notifications or alert\nwhen you do the over expenses',
      },
      {
        'image': 'assets/images/onboarding_slide_3_illustration.svg',
        'title': 'Easy to Track and Analize',
        'description':
            'Tracking your expense help make sure\nyou don\'t overspend',
      },
    ];

    return _OnboardingSlide(
      key: ValueKey('onboarding_$index'),
      image: slides[index]['image']!,
      title: slides[index]['title']!,
      description: slides[index]['description']!,
    );
  }

  Widget _buildBottomSection(BuildContext context) { // Nhận context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPageIndicator(context), // Truyền context
          const SizedBox(height: 40),
          // Cân nhắc thay CustomButton bằng ElevatedButton để đồng bộ hoàn toàn
          CustomButton(
            text: _currentPage == 2 ? "LET'S GO" : "NEXT",
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) { // Nhận context
    final colorScheme = Theme.of(context).colorScheme;
    return SmoothPageIndicator(
      controller: _pageController,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: colorScheme.primary, // Cập nhật màu
        dotColor: colorScheme.surfaceVariant, // Cập nhật màu
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
    // final colorScheme = Theme.of(context).colorScheme; // không cần nếu textTheme đã có màu

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 240, // Chiều cao cố định để tránh tràn viền
            child: SvgPicture.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium, // Cập nhật style (16pt, w600)
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(height: 1.5), // Cập nhật style (16pt, w400)
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
