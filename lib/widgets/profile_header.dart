import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: AppColors.primary,
          backgroundImage: user.image.isNotEmpty
              ? NetworkImage(user.image)
              : null,
          child: user.image.isEmpty
              ? const Icon(Icons.person, size: 55, color: Colors.white)
              : null,
        ),

        const SizedBox(height: 15),

        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(user.email, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
