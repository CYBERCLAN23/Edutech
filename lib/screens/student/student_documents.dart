import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class StudentDocuments extends StatefulWidget {
  const StudentDocuments({super.key});

  @override
  State<StudentDocuments> createState() => _StudentDocumentsState();
}

class _StudentDocumentsState extends State<StudentDocuments> {
  String _category = 'All Files';

  final _docs = <Map<String, dynamic>>[
    {'name': 'Biology 101 - Cell Structure', 'type': 'PDF', 'size': '2.4 MB', 'cat': 'Lessons', 'icon': Icons.description, 'color': const Color(0xFF00677F)},
    {'name': 'Math Exercises - Calculus', 'type': 'DOCX', 'size': '1.1 MB', 'cat': 'Exercises', 'icon': Icons.assignment, 'color': const Color(0xFF055DB6)},
    {'name': 'History AI Summary', 'type': 'TXT', 'size': '45 KB', 'cat': 'Notes', 'icon': Icons.notes, 'color': const Color(0xFF406900)},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_category == 'All Files') return _docs;
    return _docs.where((d) => d['cat'] == _category).toList();
  }

  Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggerItem(index: 0, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('My Documents',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                    SizedBox(height: 4),
                    Text('Manage your downloaded lessons and materials.',
                      style: TextStyle(fontSize: 18, color: Color(0xFF3C494E))),
                  ],
                )),
                const SizedBox(height: 24),
                StaggerItem(index: 1, child: SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _DocFilterChip(label: 'All Files', selected: _category == 'All Files', onTap: () => setState(() => _category = 'All Files')),
                      _DocFilterChip(label: 'Lessons', selected: _category == 'Lessons', onTap: () => setState(() => _category = 'Lessons')),
                      _DocFilterChip(label: 'Exercises', selected: _category == 'Exercises', onTap: () => setState(() => _category = 'Exercises')),
                      _DocFilterChip(label: 'Notes', selected: _category == 'Notes', onTap: () => setState(() => _category = 'Notes')),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.folder_open_rounded, size: 56, color: const Color(0xFF6C797F).withOpacity(0.3)),
                          const SizedBox(height: 12),
                          const Text('No documents found',
                            style: TextStyle(fontSize: 15, color: Color(0xFF3C494E))),
                        ],
                      ),
                    ),
                  )
                else
                  ...filtered.asMap().entries.map((e) {
                    final d = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: StaggerItem(
                        index: e.key + 2,
                        child: GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 40,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 48, height: 48,
                                      decoration: BoxDecoration(
                                        color: (d['color'] as Color).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(d['icon'] as IconData, size: 28, color: d['color'] as Color),
                                    ),
                                    GestureDetector(
                                      onTap: () => HapticFeedback.lightImpact(),
                                      child: Icon(Icons.more_vert, size: 20,
                                        color: const Color(0xFF3C494E)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(d['name'] as String,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700,
                                    color: Color(0xFF191C1E))),
                                const SizedBox(height: 4),
                                Text('${d['type']}  \u2022  ${d['size']}',
                                  style: const TextStyle(fontSize: 14,
                                    color: Color(0xFF3C494E))),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECEEF0),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(d['cat'] as String,
                                          style: const TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w700,
                                            color: Color(0xFF6C797F))),
                                      ),
                                      Container(
                                        width: 40, height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F9FB),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(Icons.download, size: 20,
                                          color: const Color(0xFF00677F)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF00677F), Color(0xFF055DB6)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00677F).withOpacity(0.3),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showUploadDialog();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: const Color(0xFFBBC9CF), borderRadius: BorderRadius.circular(2)),
            ),
            const Text('Ajouter un document',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            const SizedBox(height: 20),
            _UploadOption(icon: Icons.camera_alt_rounded, title: 'Prendre une photo',
              subtitle: 'Numerise un cours ou un exercice', color: const Color(0xFF00677F)),
            const SizedBox(height: 12),
            _UploadOption(icon: Icons.folder_open_rounded, title: 'Choisir un fichier',
              subtitle: 'PDF, Word, Image...', color: const Color(0xFF055DB6)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DocFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DocFilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00D2FF).withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF00D2FF) : const Color(0xFFBBC9CF),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(label,
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF00566A) : const Color(0xFF3C494E),
          )),
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color;
  const _UploadOption({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Document ajoute avec succes'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color(0xFF191C1E),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBBC9CF).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF3C494E))),
            ])),
          ],
        ),
      ),
    );
  }
}
