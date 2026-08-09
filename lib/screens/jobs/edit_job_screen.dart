import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({super.key});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController companyController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  late TextEditingController descriptionController;
  late TextEditingController requirementsController;

  late DateTime deadline;

  late JobModel job;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    job = ModalRoute.of(context)!.settings.arguments as JobModel;

    titleController = TextEditingController(text: job.title);
    companyController = TextEditingController(text: job.company);
    locationController = TextEditingController(text: job.location);
    salaryController = TextEditingController(text: job.salary);
    descriptionController = TextEditingController(text: job.description);
    requirementsController = TextEditingController(text: job.requirements);

    deadline = job.deadline;
  }

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
      initialDate: deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        deadline = picked;
      });
    }
  }

  Future<void> updateJob() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedJob = job.copyWith(
      title: titleController.text.trim(),
      company: companyController.text.trim(),
      location: locationController.text.trim(),
      salary: salaryController.text.trim(),
      description: descriptionController.text.trim(),
      requirements: requirementsController.text.trim(),
      deadline: deadline,
    );

    await context.read<JobProvider>().updateJob(updatedJob);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Job Updated Successfully")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Job")),
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
                hintText: "Description",
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
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  "${deadline.day}/${deadline.month}/${deadline.year}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  onPressed: selectDeadline,
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(text: "Update Job", onPressed: updateJob),
            ],
          ),
        ),
      ),
    );
  }
}
