import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/resume_model.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/resume_card.dart';

class UploadResumeScreen extends StatelessWidget {
  const UploadResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Resume"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<ResumeModel?>(
          stream: provider.getResume(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final resume = snapshot.data;

            return Column(
              children: [
                CustomButton(
                  text: resume == null ? "Upload Resume" : "Replace Resume",
                  isLoading: provider.isLoading,
                  onPressed: () async {
                    try {
                      await provider.pickAndUploadResume();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Resume Uploaded Successfully"),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: resume == null
                      ? const EmptyWidget(message: "No Resume Uploaded")
                      : ResumeCard(resume: resume),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
