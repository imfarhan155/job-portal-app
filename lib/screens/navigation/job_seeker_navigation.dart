import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';

import '../home/home_screen.dart';
import '../jobs/applied_jobs_screen.dart';
import '../profile/profile_screen.dart';
import '../resume/upload_resume_screen.dart';

class JobSeekerNavigation extends StatefulWidget {
  const JobSeekerNavigation({super.key});

  @override
  State<JobSeekerNavigation> createState() => _JobSeekerNavigationState();
}

class _JobSeekerNavigationState extends State<JobSeekerNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    AppliedJobsScreen(),
    UploadResumeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Portal"),
        centerTitle: true,
        actions: [
          StreamBuilder<List<NotificationModel>>(
            stream: context.read<NotificationProvider>().getNotifications(),
            builder: (context, snapshot) {
              print("========== Notification Debug ==========");
              print("Connection: ${snapshot.connectionState}");
              print("Has Data: ${snapshot.hasData}");
              print("Docs: ${snapshot.data?.length}");

              final notifications = snapshot.data ?? [];

              for (final n in notifications) {
                print(
                  "ID: ${n.notificationId} | Read: ${n.isRead} | User: ${n.userId}",
                );
              }

              final unreadCount = notifications.where((e) => !e.isRead).length;

              print("Unread Count: $unreadCount");
              print("=======================================");

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),

                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? "99+" : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: "Applied",
          ),
          NavigationDestination(
            icon: Icon(Icons.picture_as_pdf_outlined),
            selectedIcon: Icon(Icons.picture_as_pdf),
            label: "Resume",
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
