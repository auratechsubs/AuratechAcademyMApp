import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/constant_colors.dart';
import '../modules/Homescreen_module/View/HomeScreen.dart';
import '../modules/Introduction_module/View/Blog_Screen.dart';
import '../modules/My_course_module/View/My_Courses.dart';
import '../modules/Setting_Module/View/Setting_Screen.dart';

class BottomnavBar extends StatefulWidget {
  const BottomnavBar({super.key});

  @override
  State<BottomnavBar> createState() => _BottomnavBarState();
}

class _BottomnavBarState extends State<BottomnavBar> {
  final PageController _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  final List<Widget> _screens = [
      HomeScreen(),
    const MyCourses(),
      BlogScreen(),
    const SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    log('Tapped index: $index');
    _controller.index = index;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bottomBarHeight = isTablet ? 80.0 : 70.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final fontSize = isTablet ? 13.0 : 11.0;
    final bottomBarColor = isDarkMode ? AppColors.primaryDark : AppColors.primary;
    final activeIconColor = isDarkMode ? AppColors.background : AppColors.background;
    final inactiveIconColor = isDarkMode ? AppColors.textSecondary : AppColors.background;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        bottomBarHeight: bottomBarHeight,
        bottomBarWidth: size.width,
        notchBottomBarController: _controller,
        color: bottomBarColor,
        showLabel: true,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: isTablet ? 24.0 : 20.0,
        notchColor: bottomBarColor,
        textOverflow: TextOverflow.ellipsis,
        itemLabelStyle: GoogleFonts.lato(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        kIconSize: iconSize,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: inactiveIconColor),
            activeItem: Icon(Icons.home_filled, color: activeIconColor),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add_shopping_cart_outlined, color: inactiveIconColor),
            activeItem: Icon(Icons.add_shopping_cart, color: activeIconColor),
            itemLabel: 'My Cart',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.article_outlined, color: inactiveIconColor),
            activeItem: Icon(Icons.article, color: activeIconColor),
            itemLabel: 'Blog',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.menu_outlined, color: inactiveIconColor),
            activeItem: Icon(Icons.menu, color: activeIconColor),
            itemLabel: 'More',
          ),
        ],
        onTap: _onTabTapped,
        showShadow: true,
        elevation: 8.0,
        removeMargins: false,
      ),
    );
  }
}