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
        final bool isDesktop = constraints.maxWidth >= 700;

        if (isDesktop) {
          return _buildDesktopCard(context);
        }

        return _buildMobileCard(context);
      },
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.62,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    resume.fileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A237E),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _infoItem(
                      icon: Icons.storage_outlined,
                      title: "Size",
                      value: formatSize(resume.fileSize),
                    ),
                  ),
                  Container(width: 1, height: 36, color: Colors.grey.shade300),
                  Expanded(
                    child: _infoItem(
                      icon: Icons.calendar_today_outlined,
                      title: "Uploaded",
                      value:
                          "${resume.uploadedAt.day}/${resume.uploadedAt.month}/${resume.uploadedAt.year}",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

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
  // DESKTOP / CHROME
  // ============================================================

  Widget _buildDesktopCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.70,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.red,
                        size: 38,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        resume.fileName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A237E),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Info Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 400) {
                        return Column(
                          children: [
                            _infoItem(
                              icon: Icons.storage_outlined,
                              title: "File Size",
                              value: formatSize(resume.fileSize),
                            ),
                            const SizedBox(height: 12),
                            _infoItem(
                              icon: Icons.calendar_today_outlined,
                              title: "Uploaded",
                              value:
                                  "${resume.uploadedAt.day}/${resume.uploadedAt.month}/${resume.uploadedAt.year}",
                            ),
                          ],
                        );
                      }

                      return Row(
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
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                          Expanded(
                            child: _infoItem(
                              icon: Icons.calendar_today_outlined,
                              title: "Uploaded",
                              value:
                                  "${resume.uploadedAt.day}/${resume.uploadedAt.month}/${resume.uploadedAt.year}",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A237E),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PREVIEW
  // ============================================================

  Widget _previewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3949AB),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.visibility_rounded, size: 20),
        label: const Text(
          "Preview Resume",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
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
  // DOWNLOAD
  // ============================================================

  Widget _downloadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.download_rounded, size: 20),
        label: const Text(
          "Download Resume",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
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
  // SHARE
  // ============================================================

  Widget _shareButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2979FF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.share_rounded, size: 20),
        label: const Text(
          "Share Resume",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
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
  // DELETE
  // ============================================================

  Widget _deleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.red.shade200),
          ),
        ),
        icon: const Icon(Icons.delete_rounded, size: 20),
        label: const Text(
          "Delete Resume",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
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
