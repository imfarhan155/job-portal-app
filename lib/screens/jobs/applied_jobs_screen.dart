import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../widgets/empty_widget.dart';

class AppliedJobsScreen extends StatelessWidget {
  const AppliedJobsScreen({super.key});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Colors.green;

      case "rejected":
        return Colors.red;

      case "reviewed":
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ApplicationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Applied Jobs")),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: provider.getApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Applied Jobs");
          }

          final applications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, child: Icon(Icons.work)),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Application ID",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              application.applicationId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Applied: ${application.appliedDate.day}/${application.appliedDate.month}/${application.appliedDate.year}",
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(application.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          application.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
