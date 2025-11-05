import 'package:flutter/material.dart';
import '../../../constant/constant_colors.dart';
import '../../Authentication_module/View/LoginScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> imgList =  [
    "assets/images/auratech1.jpg",
    "assets/images/auratech2.jpg",
    "assets/images/auratech1.jpg",
  ];

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Online Learning',
      'description':
      'No Pressure. Access Quality Classes and life-essential solutions.',
    },
    {
      'title': 'Learn from Anytime',
      'description': 'Education from Home that is made for Future Needs.',
    },
    {
      'title': 'Get Online Certificate',
      'description': 'Level-up your career. Learn new skills for your future.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentIndex == _onboardingData.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>   LoginScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white      ,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 22),
            child: InkWell(
              onTap: _goNext,
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imgList[index],
                      height: isTablet ? size.height * 0.4 : 300,
                      width: size.width * (isTablet ? 0.6 : 0.8),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: isTablet ? 80 : 60),
                    Text(
                      _onboardingData[index]['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 48 : 32,
                      ),
                      child: Text(
                        _onboardingData[index]['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: isTablet ? 40 : 30,
              left: isTablet ? 30 : 20,
              right: isTablet ? 30 : 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                          (index) => IndicatorDot(
                        isActive: index == _currentIndex,
                        isTablet: isTablet,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _goNext,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 18,
                        vertical: isTablet ? 12 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _currentIndex == _onboardingData.length - 1
                                ? "Get Started"
                                : "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 15,
                            ),
                          ),
                          SizedBox(width: isTablet ? 10 : 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: isTablet ? 24 : 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndicatorDot extends StatelessWidget {
  final bool isActive;
  final bool isTablet;

  const IndicatorDot({super.key, required this.isActive, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? (isTablet ? 20 : 16) : (isTablet ? 10 : 8),
      height: isTablet ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryDark : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}