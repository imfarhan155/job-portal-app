import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/empty_widget.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AdminProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users"), centerTitle: true),
      body: StreamBuilder<List<UserModel>>(
        stream: provider.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Users Found");
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                    ),
                  ),

                  title: Text(user.name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(user.email), Text("Role: ${user.role}")],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          _showEditDialog(context, user);
                        },
                      ),

                      // Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete User"),
                              content: const Text(
                                "Are you sure you want to delete this user?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),

                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await provider.deleteUser(user.uid);

                            if (!context.mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User deleted successfully"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);

    final phoneController = TextEditingController(text: user.phone);

    String role = user.role;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit User"),

          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),

                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: "Phone"),
                  ),

                  DropdownButton<String>(
                    value: role,
                    isExpanded: true,

                    items: const [
                      DropdownMenuItem(value: "user", child: Text("User")),

                      DropdownMenuItem(
                        value: "employer",
                        child: Text("Employer"),
                      ),

                      DropdownMenuItem(value: "admin", child: Text("Admin")),
                    ],

                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),

              onPressed: () async {
                final updatedUser = user.copyWith(
                  name: nameController.text,
                  phone: phoneController.text,
                  role: role,
                );

                await context.read<AdminProvider>().updateUser(updatedUser);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
