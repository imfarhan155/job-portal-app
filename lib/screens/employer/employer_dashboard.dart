import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Dashboard"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,

          children: [
            _dashboardCard(
              context,
              title: "Post Job",
              icon: Icons.add_business,
              color: Colors.deepPurple,
              route: AppRoutes.addJob,
            ),

            _dashboardCard(
              context,
              title: "My Jobs",
              icon: Icons.work,
              color: Colors.blue,
              route: AppRoutes.employerJobs,
            ),

            _dashboardCard(
              context,
              title: "Applicants",
              icon: Icons.people,
              color: Colors.green,
              route: AppRoutes.applicants,
            ),

            _dashboardCard(
              context,
              title: "Logout",
              icon: Icons.logout,
              color: Colors.red,
              route: AppRoutes.login,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () async {
        if (title == "Logout") {
          await context.read<AuthProvider>().logout();

          if (!context.mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        } else {
          Navigator.pushNamed(context, route);
        }
      },

      child: Card(
        elevation: 3,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CircleAvatar(
                radius: 30,

                backgroundColor: color.withOpacity(.15),

                child: Icon(icon, size: 30, color: color),
              ),

              const SizedBox(height: 20),

              Text(
                title,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
