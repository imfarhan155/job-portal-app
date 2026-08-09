import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  bool loading = false;

  Future<void> sendResetEmail() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter your email")));
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await AuthService.instance.resetPassword(emailController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reset email sent. Check your inbox")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            const Icon(Icons.lock_reset, size: 80),

            const SizedBox(height: 30),

            const Text(
              "Enter your email to reset password",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,

              keyboardType: TextInputType.emailAddress,

              decoration: const InputDecoration(
                labelText: "Email",

                prefixIcon: Icon(Icons.email),

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton(
                onPressed: loading ? null : sendResetEmail,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Send Reset Email"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
