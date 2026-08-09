import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;

  late UserModel user;

  bool isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = context.read<AuthProvider>().user!;

    nameController = TextEditingController(text: user.name);
    phoneController = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      final updatedUser = user.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await AuthService.instance.updateProfile(updatedUser);

      await context.read<AuthProvider>().refreshUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final updatedUser = context.watch<AuthProvider>().user ?? user;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundImage: updatedUser.image.isNotEmpty
                                ? NetworkImage(updatedUser.image)
                                : null,
                            child: updatedUser.image.isEmpty
                                ? const Icon(Icons.person, size: 45)
                                : null,
                          ),

                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.deepPurple,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: profileProvider.isUploading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                              onPressed: profileProvider.isUploading
                                  ? null
                                  : () async {
                                      final success = await profileProvider
                                          .uploadProfileImage(updatedUser.uid);

                                      if (!context.mounted) return;

                                      if (success) {
                                        await context
                                            .read<AuthProvider>()
                                            .refreshUser();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Profile picture updated successfully",
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Failed to upload profile picture",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Tap the camera icon to change your profile picture",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              CustomTextField(
                controller: nameController,
                hintText: "Full Name",
                prefixIcon: Icons.person,
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: phoneController,
                hintText: "Phone Number",
                prefixIcon: Icons.phone,
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: "Save Changes",
                isLoading: isSaving,
                onPressed: saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
