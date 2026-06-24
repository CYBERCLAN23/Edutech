import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/widgets/stagger_item.dart';
import 'package:educam_ai/services/local_storage_service.dart';

class StudentDocuments extends StatefulWidget {
  const StudentDocuments({super.key});

  @override
  State<StudentDocuments> createState() => _StudentDocumentsState();
}

class _StudentDocumentsState extends State<StudentDocuments> {
  String _category = 'Tous';
  final _docs = <Map<String, dynamic>>[
    {'name': 'Cours Maths - Ch.5 Derivation', 'cat': 'Cours', 'date': '20 Juin', 'size': '2.4 MB', 'icon': Icons.picture_as_pdf_rounded, 'color': EduCamColors.subjectMaths},
    {'name': 'Exercice Fractions algebriques', 'cat': 'Exercices', 'date': '18 Juin', 'size': '1.1 MB', 'icon': Icons.edit_note_rounded, 'color': EduCamColors.accent},
    {'name': 'Note de revision SVT', 'cat': 'Notes', 'date': '15 Juin', 'size': '0.8 MB', 'icon': Icons.notes_rounded, 'color': EduCamColors.subjectSVT},
    {'name': 'Annales BAC Maths 2024', 'cat': 'Cours', 'date': '10 Juin', 'size': '3.2 MB', 'icon': Icons.picture_as_pdf_rounded, 'color': EduCamColors.subjectMaths},
    {'name': 'Correction TP Physique', 'cat': 'Exercices', 'date': '8 Juin', 'size': '1.5 MB', 'icon': Icons.science_rounded, 'color': EduCamColors.subjectPhysique},
    {'name': 'Fiche revision Histoire', 'cat': 'Notes', 'date': '5 Juin', 'size': '0.6 MB', 'icon': Icons.public_rounded, 'color': EduCamColors.subjectHistoire},
    {'name': 'Grammaire - Temps verbaux', 'cat': 'Cours', 'date': '2 Juin', 'size': '1.8 MB', 'icon': Icons.menu_book_rounded, 'color': EduCamColors.subjectFrancais},
    {'name': 'Dissertation corrigee', 'cat': 'Exercices', 'date': '28 Mai', 'size': '2.0 MB', 'icon': Icons.assignment_rounded, 'color': EduCamColors.subjectAnglais},
  ];

  List<Map<String, dynamic>> get _filtered {
    final offlineDocs = LocalStorageService().getAllResources().map((r) => {
      'name': r['title'] ?? r['id'],
      'cat': 'Hors ligne',
      'date': _formatDate(r['download_time']),
      'size': 'Stocke localement',
      'icon': Icons.offline_pin_rounded,
      'color': EduCamColors.success,
      'isOffline': true,
    }).toList();

    final all = [...offlineDocs, ..._docs];
    if (_category == 'Tous') return all;
    if (_category == 'Hors ligne') return offlineDocs;
    return all.where((d) => d['cat'] == _category).toList();
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  static const _months = ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'];

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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const StaggerItem(index: 0, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mes documents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
                        SizedBox(height: 4),
                        Text('8 documents, 12.6 MB', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText)),
                      ],
                    )),
                    StaggerItem(
                      index: 0,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _showUploadDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EduCamColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.upload_rounded, size: 22, color: EduCamColors.accent),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StaggerItem(
                  index: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: EduCamColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, size: 20, color: EduCamColors.secondaryText),
                        SizedBox(width: 10),
                        Expanded(child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher un document...',
                            border: InputBorder.none, enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StaggerItem(
                  index: 2,
                  child: SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final labels = ['Tous', 'Hors ligne', 'Cours', 'Exercices', 'Notes'];
                        final label = labels[i];
                        final selected = label == _category;
                        return GestureDetector(
                          onTap: () { HapticFeedback.lightImpact(); setState(() => _category = label); },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected ? EduCamColors.accent : EduCamColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selected ? EduCamColors.accent : EduCamColors.cardBorder, width: 0.5),
                            ),
                            child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: selected ? EduCamColors.surface : EduCamColors.secondaryText)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const Padding(padding: EdgeInsets.only(top: 40), child: Center(child: Text('Aucun document', style: TextStyle(fontSize: 14, color: EduCamColors.secondaryText))))
                else
                  ...filtered.asMap().entries.map((e) {
                    final d = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: StaggerItem(
                        index: e.key + 3,
                        child: GestureDetector(
                          onTap: () => HapticFeedback.lightImpact(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: EduCamColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    color: (d['color'] as Color).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(d['icon'] as IconData, size: 18, color: d['color'] as Color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(d['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                                    const SizedBox(height: 2),
                                    Text('${d['date']} - ${d['size']}', style: const TextStyle(fontSize: 11, color: EduCamColors.secondaryText)),
                                  ],
                                )),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (d['color'] as Color).withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(d['cat'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: (d['color'] as Color).withValues(alpha: 0.7))),
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
    );
  }

  void _showUploadDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: EduCamColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: EduCamColors.cardBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const Text('Ajouter un document', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EduCamColors.primary)),
            const SizedBox(height: 20),
            _UploadOption(icon: Icons.camera_alt_rounded, title: 'Prendre une photo', subtitle: 'Numerise un cours ou un exercice', color: EduCamColors.accent),
            const SizedBox(height: 12),
            _UploadOption(icon: Icons.folder_open_rounded, title: 'Choisir un fichier', subtitle: 'PDF, Word, Image...', color: EduCamColors.highlight),
            const SizedBox(height: 12),
            _UploadOption(icon: Icons.cloud_upload_rounded, title: 'Importer du cloud', subtitle: 'Google Drive, OneDrive...', color: EduCamColors.subjectPhysique),
            const SizedBox(height: 20),
          ],
        ),
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
            backgroundColor: EduCamColors.primary,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: EduCamColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: EduCamColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: EduCamColors.secondaryText)),
            ])),
          ],
        ),
      ),
    );
  }
}
