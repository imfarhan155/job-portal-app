import 'package:flutter/material.dart';

import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 28, child: Icon(Icons.business)),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          job.company,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),

                  const SizedBox(width: 5),

                  Text(job.location),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.payments, size: 18, color: Colors.green),

                  const SizedBox(width: 5),

                  Text(job.salary),
                ],
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: onTap,
                  child: const Text("View Details"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
