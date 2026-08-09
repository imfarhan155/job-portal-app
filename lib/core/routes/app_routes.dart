import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/notification/notification_screen.dart';
import 'package:flutter/material.dart';

// Splash
import '../../screens/splash/splash_screen.dart';

// Auth
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';

// User
import '../../screens/home/home_screen.dart';
import '../../screens/jobs/job_details_screen.dart';
import '../../screens/jobs/applied_jobs_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';

// Resume
import '../../screens/resume/upload_resume_screen.dart';
import '../../screens/resume/resume_preview_screen.dart';

// Employer
import '../../screens/employer/employer_dashboard.dart';
import '../../screens/jobs/add_job_screen.dart';
import '../../screens/jobs/edit_job_screen.dart';
import '../../screens/jobs/employer_jobs_screen.dart';
import '../../screens/jobs/applicants_screen.dart';

// Admin
import '../../screens/admin/admin_dashboard.dart';
import '../../screens/admin/manage_users_screen.dart';
import '../../screens/admin/manage_jobs_screen.dart';
import '../../screens/admin/statistics_screen.dart';

// Navigation
import '../../screens/navigation/job_seeker_navigation.dart';
import '../../screens/navigation/employer_navigation.dart';

class AppRoutes {
  // Splash
  static const String splash = "/";

  // Auth
  static const String login = "/login";
  static const String signup = "/signup";

  // User
  static const String home = "/home";
  static const String jobDetails = "/jobDetails";
  static const String appliedJobs = "/appliedJobs";
  static const String profile = "/profile";
  static const String editProfile = "/editProfile";

  // Resume
  static const String uploadResume = "/uploadResume";
  static const String resumePreview = "/resumePreview";

  // Employer
  static const String employerDashboard = "/employerDashboard";
  static const String addJob = "/addJob";
  static const String editJob = "/editJob";
  static const String employerJobs = "/employerJobs";
  static const String applicants = "/applicants";

  // Admin
  static const String adminDashboard = "/adminDashboard";
  static const String manageUsers = "/manageUsers";
  static const String manageJobs = "/manageJobs";
  static const String statistics = "/statistics";

  // Navigation
  static const String jobSeekerNavigation = "/jobSeekerNavigation";
  static const String employerNavigation = "/employerNavigation";
  // Notification
  static const String notifications = "/notifications";
  static const String forgotPassword = "/forgotPassword";

  static final Map<String, WidgetBuilder> routes = {
    // Splash
    splash: (_) => const SplashScreen(),

    // Auth
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),

    // User
    home: (_) => const HomeScreen(),
    jobDetails: (_) => const JobDetailsScreen(),
    appliedJobs: (_) => const AppliedJobsScreen(),
    profile: (_) => const ProfileScreen(),
    editProfile: (_) => const EditProfileScreen(),

    // Resume
    uploadResume: (_) => const UploadResumeScreen(),
    resumePreview: (_) => const ResumePreviewScreen(),

    // Employer
    employerDashboard: (_) => const EmployerDashboard(),
    addJob: (_) => const AddJobScreen(),
    editJob: (_) => const EditJobScreen(),
    employerJobs: (_) => const EmployerJobsScreen(),
    applicants: (_) => const ApplicantsScreen(),

    // Admin
    adminDashboard: (_) => const AdminDashboard(),
    manageUsers: (_) => const ManageUsersScreen(),
    manageJobs: (_) => const ManageJobsScreen(),
    statistics: (_) => const StatisticsScreen(),

    // Navigation
    jobSeekerNavigation: (_) => const JobSeekerNavigation(),
    employerNavigation: (_) => const EmployerNavigation(),
    // Notification
    notifications: (_) => const NotificationScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
  };
}
