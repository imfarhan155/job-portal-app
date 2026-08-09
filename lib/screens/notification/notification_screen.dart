import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/empty_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: StreamBuilder<List<NotificationModel>>(
        stream: provider.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: "No Notifications");
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Dismissible(
                key: Key(notification.notificationId),

                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                onDismissed: (_) {
                  provider.deleteNotification(notification.notificationId);
                },

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.isRead
                        ? Colors.grey.shade300
                        : Colors.blue,

                    child: Icon(
                      notification.isRead
                          ? Icons.notifications_none
                          : Icons.notifications,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(notification.title),

                  subtitle: Text(notification.message),

                  trailing: Text(
                    "${notification.createdAt.day}/${notification.createdAt.month}",
                  ),

                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
