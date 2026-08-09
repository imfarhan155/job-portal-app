import 'package:flutter/material.dart';

import '../employer/employer_dashboard.dart';
import '../jobs/employer_jobs_screen.dart';
import '../profile/profile_screen.dart';

class EmployerNavigation extends StatefulWidget {
  const EmployerNavigation({super.key});

  @override
  State<EmployerNavigation> createState() => _EmployerNavigationState();
}

class _EmployerNavigationState extends State<EmployerNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    EmployerDashboard(),

    EmployerJobsScreen(),

    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),

            selectedIcon: Icon(Icons.dashboard),

            label: "Dashboard",
          ),

          NavigationDestination(
            icon: Icon(Icons.work_outline),

            selectedIcon: Icon(Icons.work),

            label: "My Jobs",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),

            selectedIcon: Icon(Icons.person),

            label: "Profile",
          ),
        ],
      ),
    );
  }
}
