import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/validators.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();

  DateTime? deadline;

  @override
  void dispose() {
    titleController.dispose();
    companyController.dispose();
    locationController.dispose();
    salaryController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    super.dispose();
  }

  Future<void> selectDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        deadline = picked;
      });
    }
  }

  Future<void> saveJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (deadline == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select deadline")));
      return;
    }

    final employerId = AuthService.instance.currentUser!.uid;

    final job = JobModel(
      jobId: const Uuid().v4(),
      title: titleController.text.trim(),
      company: companyController.text.trim(),
      location: locationController.text.trim(),
      salary: salaryController.text.trim(),
      description: descriptionController.text.trim(),
      requirements: requirementsController.text.trim(),
      employerId: employerId,
      deadline: deadline!,
      createdAt: DateTime.now(),
    );

    await context.read<JobProvider>().addJob(job);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Job Posted Successfully")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FF), Color(0xFFEEF1FF), Color(0xFFE8ECFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post New Job",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Fill the details below",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Main Form Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: titleController,
                                hintText: "Job Title",
                                prefixIcon: Icons.work_outline_rounded,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: companyController,
                                hintText: "Company Name",
                                prefixIcon: Icons.business_rounded,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: locationController,
                                hintText: "Location",
                                prefixIcon: Icons.location_on_outlined,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: salaryController,
                                hintText: "Salary",
                                prefixIcon: Icons.payments_outlined,
                                keyboardType: TextInputType.number,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: descriptionController,
                                hintText: "Job Description",
                                prefixIcon: Icons.description_outlined,
                                maxLines: 5,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 16),

                              CustomTextField(
                                controller: requirementsController,
                                hintText: "Requirements",
                                prefixIcon: Icons.list_alt_rounded,
                                maxLines: 4,
                                validator: Validators.validateName,
                              ),

                              const SizedBox(height: 20),

                              // Deadline Selector
                              GestureDetector(
                                onTap: selectDeadline,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF3949AB,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.calendar_month_rounded,
                                          color: Color(0xFF3949AB),
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Application Deadline",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              deadline == null
                                                  ? "Select Deadline"
                                                  : "${deadline!.day}/${deadline!.month}/${deadline!.year}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: deadline == null
                                                    ? Colors.grey.shade500
                                                    : const Color(0xFF1A237E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              CustomButton(
                                text: "Post Job",
                                onPressed: saveJob,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
