import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumePreviewScreen extends StatelessWidget {
  const ResumePreviewScreen({super.key});

  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open resume.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String fileUrl = args?["fileUrl"] ?? "";
    final String fileName = args?["fileName"] ?? "Resume";

    if (fileUrl.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Resume"), centerTitle: true),
        body: const Center(
          child: Text("Resume not found.", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    // Flutter Web
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _openPdf(fileUrl);
        if (context.mounted) {
          Navigator.pop(context);
        }
      });

      return Scaffold(
        appBar: AppBar(title: Text(fileName), centerTitle: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Android / iOS
    return Scaffold(
      appBar: AppBar(title: Text(fileName), centerTitle: true),
      body: SfPdfViewer.network(
        fileUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
      ),
    );
  }
}
