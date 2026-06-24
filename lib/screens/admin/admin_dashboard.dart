import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/services/admin_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final d = await AdminService().getDashboard();
      if (mounted) setState(() { _data = d; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Utilisateurs', _data?['totalUsers'] ?? 0, Icons.people_rounded, EduCamColors.accent),
      ('Élèves', _data?['totalStudents'] ?? 0, Icons.school_rounded, EduCamColors.success),
      ('Professeurs', _data?['totalTeachers'] ?? 0, Icons.person_rounded, EduCamColors.highlight),
      ('Cours', _data?['totalCourses'] ?? 0, Icons.book_rounded, EduCamColors.accent),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: EduCamColors.surface,
        elevation: 0,
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _load, child: const Text('Réessayer')),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (_, i) {
                    final (label, value, icon, color) = stats[i];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: color, size: 24),
                          const Spacer(),
                          Text('$value', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: EduCamColors.secondaryText)),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
