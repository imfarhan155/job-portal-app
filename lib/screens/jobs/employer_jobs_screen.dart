import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/empty_widget.dart';

class EmployerJobsScreen extends StatelessWidget {
  const EmployerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employerId = AuthService.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Jobs")),
      body: StreamBuilder<List<JobModel>>(
        stream: context.read<JobProvider>().getEmployerJobs(employerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Jobs Posted");
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(job.company),

                      const SizedBox(height: 5),

                      Text(job.location),

                      const SizedBox(height: 5),

                      Text(job.salary),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editJob,
                                arguments: job,
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await context.read<JobProvider>().deleteJob(
                                job.jobId,
                              );
                            },
                          ),
                        ],
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
