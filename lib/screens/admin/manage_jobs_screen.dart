import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/job_model.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/empty_widget.dart';

class ManageJobsScreen extends StatelessWidget {
  const ManageJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Jobs"), centerTitle: true),

      body: StreamBuilder<List<JobModel>>(
        stream: provider.getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Jobs Found");
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,

            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.work)),

                  title: Text(job.title),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(job.company),

                      Text(job.location),

                      Text(job.salary),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // EDIT BUTTON
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),

                        onPressed: () {
                          _showEditDialog(context, job);
                        },
                      ),

                      // DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,

                            builder: (_) => AlertDialog(
                              title: const Text("Delete Job"),

                              content: const Text(
                                "Are you sure you want to delete this job?",
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),

                                  child: const Text("Cancel"),
                                ),

                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),

                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await provider.deleteJob(job.jobId);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Job deleted successfully"),
                              ),
                            );
                          }
                        },
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

  void _showEditDialog(BuildContext context, JobModel job) {
    final titleController = TextEditingController(text: job.title);

    final companyController = TextEditingController(text: job.company);

    final locationController = TextEditingController(text: job.location);

    final salaryController = TextEditingController(text: job.salary);

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Job"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: titleController,

                  decoration: const InputDecoration(labelText: "Job Title"),
                ),

                TextField(
                  controller: companyController,

                  decoration: const InputDecoration(labelText: "Company"),
                ),

                TextField(
                  controller: locationController,

                  decoration: const InputDecoration(labelText: "Location"),
                ),

                TextField(
                  controller: salaryController,

                  decoration: const InputDecoration(labelText: "Salary"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),

              onPressed: () async {
                final updatedJob = job.copyWith(
                  title: titleController.text,

                  company: companyController.text,

                  location: locationController.text,

                  salary: salaryController.text,
                );

                await context.read<AdminProvider>().updateJob(updatedJob);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
