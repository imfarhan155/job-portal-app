import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/application_model.dart';
import '../../providers/application_provider.dart';
import '../../widgets/empty_widget.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

  Color statusColor(String status) {
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

  Future<void> updateStatus(
    BuildContext context,
    ApplicationModel application,
    String status,
  ) async {
    await context.read<ApplicationProvider>().updateStatus(
      application.applicationId,
      status,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Application $status")));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ApplicationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Applicants"), centerTitle: true),

      body: StreamBuilder<List<ApplicationModel>>(
        stream: provider.getApplications(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Applicants Found");
          }

          final applicants = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: applicants.length,

            itemBuilder: (context, index) {
              final application = applicants[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            child: Icon(Icons.person),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  application.applicantName,

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(application.applicantEmail),

                                Text(application.applicantPhone),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Job: ${application.jobTitle}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 5),

                      Text("Company: ${application.companyName}"),

                      const SizedBox(height: 5),

                      Text(
                        "Applied: ${application.appliedDate.day}/${application.appliedDate.month}/${application.appliedDate.year}",
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: statusColor(application.status),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              application.status,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const Spacer(),

                          if (application.status == "Pending") ...[
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),

                              onPressed: () {
                                updateStatus(context, application, "Accepted");
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),

                              onPressed: () {
                                updateStatus(context, application, "Rejected");
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,

                        child: OutlinedButton.icon(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.green,
                          ),

                          label: const Text(
                            "View Resume",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/resumePreview",

                              arguments: {
                                "fileUrl": application.resumeUrl,
                                "fileName": application.resumeName,
                              },
                            );
                          },
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
