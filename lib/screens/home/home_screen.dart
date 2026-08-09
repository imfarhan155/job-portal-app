import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/job_provider.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/job_card.dart';
import '../../core/routes/app_routes.dart';
import '../../models/job_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Available Jobs"), centerTitle: true),

      body: StreamBuilder<List<JobModel>>(
        stream: provider.getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Jobs Available");
          }

          final jobs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];

              return JobCard(
                job: job,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.jobDetails,
                    arguments: job,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
