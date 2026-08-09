import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/resume_model.dart';
import '../providers/resume_provider.dart';
import '../services/resume_service.dart';

class ResumeCard extends StatelessWidget {
  final ResumeModel resume;

  const ResumeCard({super.key, required this.resume});

  String formatSize(int bytes) {
    final kb = bytes / 1024;

    if (kb < 1024) {
      return "${kb.toStringAsFixed(1)} KB";
    }

    final mb = kb / 1024;

    return "${mb.toStringAsFixed(2)} MB";
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open resume.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = kIsWeb && constraints.maxWidth >= 700;

        if (isDesktop) {
          return _buildDesktopCard(context);
        }

        return _buildMobileCard(context);
      },
    );
  }

  // ============================================================
  // MOBILE
  // Existing mobile layout kept simple and unchanged
  // ============================================================

  Widget _buildMobileCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 45),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    resume.fileName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text("Size: ${formatSize(resume.fileSize)}"),

            const SizedBox(height: 8),

            Text(
              "Uploaded: "
              "${resume.uploadedAt.day}/"
              "${resume.uploadedAt.month}/"
              "${resume.uploadedAt.year}",
            ),

            const SizedBox(height: 20),

            _previewButton(context),

            const SizedBox(height: 10),

            _downloadButton(context),

            const SizedBox(height: 10),

            _shareButton(context),

            const SizedBox(height: 10),

            _deleteButton(context),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP / WEB
  // Responsive + Scrollable
  // ============================================================

  Widget _buildDesktopCard(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 560),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                          size: 42,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Text(
                          resume.fileName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoItem(
                            icon: Icons.storage_outlined,
                            title: "File Size",
                            value: formatSize(resume.fileSize),
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 45,
                          color: Colors.grey.shade300,
                        ),

                        Expanded(
                          child: _infoItem(
                            icon: Icons.calendar_today_outlined,
                            title: "Uploaded",
                            value:
                                "${resume.uploadedAt.day}/"
                                "${resume.uploadedAt.month}/"
                                "${resume.uploadedAt.year}",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _previewButton(context),

                  const SizedBox(height: 12),

                  _downloadButton(context),

                  const SizedBox(height: 12),

                  _shareButton(context),

                  const SizedBox(height: 12),

                  _deleteButton(context),

                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade700),

        const SizedBox(width: 10),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PREVIEW BUTTON
  // ============================================================

  Widget _previewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.visibility),
        label: const Text("Preview Resume"),
        onPressed: () async {
          try {
            if (kIsWeb) {
              final uri = Uri.parse(resume.fileUrl);

              await launchUrl(uri, webOnlyWindowName: "_blank");
            } else {
              Navigator.pushNamed(
                context,
                "/resumePreview",
                arguments: {
                  "fileUrl": resume.fileUrl,
                  "fileName": resume.fileName,
                },
              );
            }
          } catch (e) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  // ============================================================
  // DOWNLOAD BUTTON
  // ============================================================

  Widget _downloadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        label: const Text("Download Resume"),
        onPressed: () async {
          try {
            if (kIsWeb) {
              final uri = Uri.parse(resume.fileUrl);

              await launchUrl(uri, webOnlyWindowName: "_blank");
            } else {
              final filePath = await ResumeService.instance.downloadResume(
                resume.fileUrl,
                resume.fileName,
              );

              await OpenFilex.open(filePath);
            }
          } catch (e) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  // ============================================================
  // SHARE BUTTON
  // ============================================================

  Widget _shareButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.share),
        label: const Text("Share Resume"),
        onPressed: () async {
          try {
            if (kIsWeb) {
              final uri = Uri.parse(resume.fileUrl);

              await launchUrl(uri, webOnlyWindowName: "_blank");
            } else {
              final filePath = await ResumeService.instance.downloadResume(
                resume.fileUrl,
                resume.fileName,
              );

              await Share.shareXFiles([XFile(filePath)], text: resume.fileName);
            }
          } catch (e) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  // ============================================================
  // DELETE BUTTON
  // ============================================================

  Widget _deleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.delete),
        label: const Text("Delete Resume"),
        onPressed: () async {
          try {
            await context.read<ResumeProvider>().deleteResume(resume);

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Resume deleted successfully")),
            );
          } catch (e) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }
}
