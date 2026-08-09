import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminProvider>().loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics"), centerTitle: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _tile(
                  "Total Users",
                  provider.totalUsers,
                  Icons.people,
                  Colors.blue,
                ),
                _tile(
                  "Total Employers",
                  provider.totalEmployers,
                  Icons.business,
                  Colors.deepPurple,
                ),
                _tile(
                  "Total Jobs",
                  provider.totalJobs,
                  Icons.work,
                  Colors.orange,
                ),
                _tile(
                  "Total Applications",
                  provider.totalApplications,
                  Icons.description,
                  Colors.teal,
                ),
                _tile(
                  "Accepted",
                  provider.acceptedApplications,
                  Icons.check_circle,
                  Colors.green,
                ),
                _tile(
                  "Rejected",
                  provider.rejectedApplications,
                  Icons.cancel,
                  Colors.red,
                ),
                _tile(
                  "Pending",
                  provider.pendingApplications,
                  Icons.schedule,
                  Colors.amber,
                ),
              ],
            ),
    );
  }

  Widget _tile(String title, int value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
