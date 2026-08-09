import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/application_model.dart';
import '../../models/job_model.dart';
import '../../providers/application_provider.dart';
import '../../services/auth_service.dart';
import '../../services/resume_service.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobModel job = ModalRoute.of(context)!.settings.arguments as JobModel;

    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              job.company,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(job.location),
            ),

            ListTile(
              leading: const Icon(Icons.payments),
              title: Text(job.salary),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                "${job.deadline.day}/${job.deadline.month}/${job.deadline.year}",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Job Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(job.description),

            const SizedBox(height: 25),

            const Text(
              "Requirements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(job.requirements),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final uid = AuthService.instance.currentUser!.uid;

                  // Get current user
                  final currentUser = await AuthService.instance.getUserData(
                    uid,
                  );

                  if (currentUser == null) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User data not found.")),
                    );
                    return;
                  }

                  // Check if already applied
                  final alreadyApplied = await context
                      .read<ApplicationProvider>()
                      .hasAlreadyApplied(jobId: job.jobId, userId: uid);

                  if (alreadyApplied) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You have already applied for this job."),
                      ),
                    );
                    return;
                  }

                  // Check resume
                  final resume = await ResumeService.instance.getResume(uid);

                  if (resume == null) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please upload your resume before applying.",
                        ),
                      ),
                    );
                    return;
                  }

                  // Create application
                  final application = ApplicationModel(
                    applicationId: const Uuid().v4(),
                    jobId: job.jobId,
                    jobTitle: job.title,
                    companyName: job.company,
                    userId: uid,
                    applicantName: currentUser.name,
                    applicantEmail: currentUser.email,
                    applicantPhone: currentUser.phone,
                    resumeUrl: resume.fileUrl,
                    resumeName: resume.fileName,
                    status: "Pending",
                    appliedDate: DateTime.now(),
                  );

                  await context.read<ApplicationProvider>().apply(application);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Application Submitted Successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Apply Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
