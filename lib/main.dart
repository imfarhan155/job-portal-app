import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

// Providers
import 'providers/admin_provider.dart';
import 'providers/application_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/resume_provider.dart';

// Theme
import 'core/theme/light_theme.dart';

// Routes
import 'core/routes/app_routes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'job_portal',
  'Job Portal Notifications',
  description: 'Application Status Notifications',
  importance: Importance.high,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: "https://dyhobnnnbfyrithyjykh.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5aG9ibm5uYmZ5cml0aHlqeWtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzNDM2NzgsImV4cCI6MjEwMDkxOTY3OH0.bDxcXosPMwZpP1gyRiE4mKYinlQYTzTsHIkMqjzlJ6w",
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'job_portal',
            'Job Portal Notifications',
            channelDescription: 'Application Status Notifications',

            importance: Importance.max,
            priority: Priority.max,

            playSound: true,
            enableVibration: true,

            autoCancel: false,

            visibility: NotificationVisibility.public,

            category: AndroidNotificationCategory.message,

            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  runApp(const JobPortalApp());
}

class JobPortalApp extends StatelessWidget {
  const JobPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ResumeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Job Portal",
        theme: lightTheme,
        routes: AppRoutes.routes,

        // Always start from Splash
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
