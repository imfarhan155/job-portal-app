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
      appBar: AppBar(title: const Text("Post New Job")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: titleController,
                hintText: "Job Title",
                prefixIcon: Icons.work,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: companyController,
                hintText: "Company Name",
                prefixIcon: Icons.business,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: locationController,
                hintText: "Location",
                prefixIcon: Icons.location_on,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: salaryController,
                hintText: "Salary",
                prefixIcon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: descriptionController,
                hintText: "Job Description",
                prefixIcon: Icons.description,
                maxLines: 5,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: requirementsController,
                hintText: "Requirements",
                prefixIcon: Icons.list_alt,
                maxLines: 4,
                validator: Validators.validateName,
              ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  deadline == null
                      ? "Select Deadline"
                      : "${deadline!.day}/${deadline!.month}/${deadline!.year}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: selectDeadline,
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(text: "Post Job", onPressed: saveJob),
            ],
          ),
        ),
      ),
    );
  }
}
