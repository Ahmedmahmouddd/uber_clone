import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/presentation/driver_home/widgets/earnings_tab.dart';
import 'package:uber_clone/presentation/driver_home/widgets/home_tab.dart';
import 'package:uber_clone/presentation/driver_home/widgets/profile_tab.dart';
import 'package:uber_clone/presentation/driver_home/widgets/ratings_tab.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTab(),
            EarningsTab(),
            RatingsTab(),
            ProfileTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Earning'),
            BottomNavigationBarItem(icon: Icon(Icons.star_rate_rounded), label: 'Rating'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
          unselectedItemColor: darkTheme ? DarkColors.accent : LightColors.textSecondary,
          selectedItemColor: darkTheme ? DarkColors.textSecondary : LightColors.primary,
          type: BottomNavigationBarType.fixed,
          onTap: onItemClicked,
          enableFeedback: false,
          selectedLabelStyle: TextStyle(fontFamily: 'poppins', fontSize: 14),
          unselectedLabelStyle: TextStyle(fontFamily: 'poppins', fontSize: 12),
          currentIndex: selectedIndex,
        ),
      ),
    );
  }
}
