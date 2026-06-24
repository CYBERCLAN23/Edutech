import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/services/admin_service.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  List<dynamic> _users = [];
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
      final users = await AdminService().getUsers();
      if (mounted) setState(() { _users = users; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: EduCamColors.surface,
        elevation: 0,
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (_, i) {
                final u = _users[i] as Map<String, dynamic>;
                final role = u['role'] as String? ?? '';
                final roleColor = role == 'teacher' ? EduCamColors.highlight
                  : role == 'admin' ? EduCamColors.accent
                  : EduCamColors.success;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: EduCamColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: roleColor.withOpacity(0.1),
                        child: Text(
                          (u['name'] as String? ?? '?')[0].toUpperCase(),
                          style: TextStyle(color: roleColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u['name'] as String? ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                            Text(u['email'] as String? ?? '', style: GoogleFonts.poppins(fontSize: 12, color: EduCamColors.secondaryText)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(role, style: GoogleFonts.poppins(fontSize: 11, color: roleColor, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
