import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String selectedRole = "job_seeker";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));

      return;
    }

    final provider = Provider.of<AuthProvider>(context, listen: false);

    final success = await provider.signUp(
      name: nameController.text.trim(),

      email: emailController.text.trim(),

      password: passwordController.text.trim(),

      phone: phoneController.text.trim(),

      role: selectedRole,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Failed")));

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully. Please login"),
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  hintText: "Full Name",
                  prefixIcon: Icons.person,
                  validator: Validators.validateName,
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: phoneController,
                  hintText: "Phone Number",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: obscurePassword,
                  validator: Validators.validatePassword,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline,
                  obscureText: obscureConfirmPassword,
                  validator: Validators.validatePassword,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                DropdownButtonFormField<String>(
                  value: selectedRole,

                  decoration: const InputDecoration(
                    labelText: "Select Role",

                    prefixIcon: Icon(Icons.badge),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: "job_seeker",

                      child: Text("Job Seeker"),
                    ),

                    DropdownMenuItem(
                      value: "employer",

                      child: Text("Employer"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: "Create Account",

                  isLoading: provider.isLoading,

                  onPressed: signUp,
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
