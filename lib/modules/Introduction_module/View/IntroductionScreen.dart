// import 'package:flutter/material.dart';
// import '../../../constant/constant_colors.dart';
// import '../../Authentication_module/View/LoginScreen.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//   final List<String> imgList =  [
//     "assets/images/auratech1.jpg",
//     "assets/images/auratech2.jpg",
//     "assets/images/auratech1.jpg",
//   ];
//
//   final List<Map<String, String>> _onboardingData = [
//     {
//       'title': 'Online Learning',
//       'description':
//       'No Pressure. Access Quality Classes and life-essential solutions.',
//     },
//     {
//       'title': 'Learn from Anytime',
//       'description': 'Education from Home that is made for Future Needs.',
//     },
//     {
//       'title': 'Get Online Certificate',
//       'description': 'Level-up your career. Learn new skills for your future.',
//     },
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _goNext() {
//     if (_currentIndex == _onboardingData.length - 1) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) =>   LoginScreen()),
//       );
//     } else {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white      ,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 22),
//             child: InkWell(
//               onTap: _goNext,
//               child: Text(
//                 "Skip",
//                 style: TextStyle(
//                   fontSize: isTablet ? 20 : 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             PageView.builder(
//               controller: _pageController,
//               itemCount: _onboardingData.length,
//               onPageChanged: (index) => setState(() => _currentIndex = index),
//               itemBuilder: (context, index) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       imgList[index],
//                       height: isTablet ? size.height * 0.4 : 300,
//                       width: size.width * (isTablet ? 0.6 : 0.8),
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(height: isTablet ? 80 : 60),
//                     Text(
//                       _onboardingData[index]['title']!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: isTablet ? 28 : 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     SizedBox(height: isTablet ? 16 : 12),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isTablet ? 48 : 32,
//                       ),
//                       child: Text(
//                         _onboardingData[index]['description']!,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: isTablet ? 18 : 16,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//             Positioned(
//               bottom: isTablet ? 40 : 30,
//               left: isTablet ? 30 : 20,
//               right: isTablet ? 30 : 20,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: List.generate(
//                       _onboardingData.length,
//                           (index) => IndicatorDot(
//                         isActive: index == _currentIndex,
//                         isTablet: isTablet,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: _goNext,
//                     borderRadius: BorderRadius.circular(30),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isTablet ? 24 : 18,
//                         vertical: isTablet ? 12 : 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryDark,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             _currentIndex == _onboardingData.length - 1
//                                 ? "Get Started"
//                                 : "Skip",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               fontSize: isTablet ? 16 : 15,
//                             ),
//                           ),
//                           SizedBox(width: isTablet ? 10 : 8),
//                           Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                             size: isTablet ? 24 : 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class IndicatorDot extends StatelessWidget {
//   final bool isActive;
//   final bool isTablet;
//
//   const IndicatorDot({super.key, required this.isActive, required this.isTablet});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       width: isActive ? (isTablet ? 20 : 16) : (isTablet ? 10 : 8),
//       height: isTablet ? 10 : 8,
//       decoration: BoxDecoration(
//         color: isActive ? AppColors.primaryDark : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(4),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  // 🎬 Replace with your Lottie JSON files (place them in assets/lottie/)
  final List<String> lottieList = [
    "assets/lottie/online_learning.json",
    "assets/lottie/flexible_learning.json",
    "assets/lottie/certification_success.json",
  ];

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Learn Anytime, Anywhere',
      'description':
      'Auratech Academy brings the classroom to your screen — learn on your schedule, at your pace.',
    },
    {
      'title': 'Future-Ready Courses',
      'description':
      'Master emerging technologies and essential digital skills designed for modern careers.',
    },
    {
      'title': 'Earn Recognized Certificates',
      'description':
      'Boost your profile with industry-verified certifications and join thousands of learners shaping the future.',
    },
  ];

  void _goNext() {
    if (_currentIndex == _onboardingData.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
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
                final data = _onboardingData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🎞 Lottie animation replaces image
                    Lottie.asset(
                      lottieList[index],
                      height: isTablet ? size.height * 0.45 : 300,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: isTablet ? 60 : 40),
                    Text(
                      data['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 30 : 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 40,
                      ),
                      child: Text(
                        data['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          height: 1.5,
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
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            _currentIndex == _onboardingData.length - 1
                                ? "Get Started"
                                : "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 18 : 16,
                            ),
                          ),
                          SizedBox(width: isTablet ? 10 : 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: isTablet ? 26 : 22,
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

  const IndicatorDot({
    super.key,
    required this.isActive,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
