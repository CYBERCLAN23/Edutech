import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class TeacherStudents extends StatefulWidget {
  const TeacherStudents({super.key});

  @override
  State<TeacherStudents> createState() => _TeacherStudentsState();
}

class _TeacherStudentsState extends State<TeacherStudents> {
  String _filter = 'All';

  final _students = <Map<String, dynamic>>[
    {'name': 'Alice Kamga', 'class': '3eme A', 'grade': 92, 'status': 'Excellent', 'color': const Color(0xFF406900), 'initials': 'AK'},
    {'name': 'Bob Nkwi', 'class': '3eme A', 'grade': 78, 'status': 'Good', 'color': const Color(0xFF055DB6), 'initials': 'BN'},
    {'name': 'Claire Tchinda', 'class': '3eme B', 'grade': 88, 'status': 'Excellent', 'color': const Color(0xFF055DB6), 'initials': 'CT'},
    {'name': 'David Fonkou', 'class': '3eme A', 'grade': 62, 'status': 'Good', 'color': const Color(0xFFC77D00), 'initials': 'DF'},
    {'name': 'Esther Mbah', 'class': '3eme B', 'grade': 45, 'status': 'At Risk', 'color': const Color(0xFFC23433), 'initials': 'EM'},
    {'name': 'Frank Taku', 'class': '3eme A', 'grade': 55, 'status': 'At Risk', 'color': const Color(0xFFC23433), 'initials': 'FT'},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _students;
    return _students.where((s) => s['status'] == _filter).toList();
  }

  Color _statusBg(String s) {
    switch (s) {
      case 'Excellent': return const Color(0xFF406900);
      case 'Good': return const Color(0xFF055DB6);
      case 'At Risk': return const Color(0xFFC23433);
      default: return const Color(0xFF6C797F);
    }
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggerItem(index: 0, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('My Students',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                    SizedBox(height: 4),
                    Text('Track your students\' performance and progress',
                      style: TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
                  ],
                )),
                const SizedBox(height: 20),
                StaggerItem(index: 1, child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(children: [
                    const Icon(Icons.search_rounded, size: 22, color: Color(0xFF6C797F)),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search students by name or class...',
                        hintStyle: const TextStyle(color: Color(0xFF6C797F), fontSize: 16),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    )),
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00677F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.tune, size: 18, color: Colors.white),
                    ),
                  ]),
                )),
                const SizedBox(height: 20),
                StaggerItem(index: 2, child: SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _FilterChip(label: 'All', count: _students.length, selected: _filter == 'All', onTap: () => setState(() => _filter = 'All')),
                      _FilterChip(label: 'Excellent', count: _students.where((s) => s['status'] == 'Excellent').length, selected: _filter == 'Excellent', onTap: () => setState(() => _filter = 'Excellent')),
                      _FilterChip(label: 'Good', count: _students.where((s) => s['status'] == 'Good').length, selected: _filter == 'Good', onTap: () => setState(() => _filter = 'Good')),
                      _FilterChip(label: 'At Risk', count: _students.where((s) => s['status'] == 'At Risk').length, selected: _filter == 'At Risk', onTap: () => setState(() => _filter = 'At Risk')),
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
                          Icon(Icons.people_outline_rounded, size: 56, color: const Color(0xFF6C797F).withOpacity(0.3)),
                          const SizedBox(height: 12),
                          const Text('No students in this category',
                            style: TextStyle(fontSize: 15, color: Color(0xFF3C494E))),
                        ],
                      ),
                    ),
                  )
                else
                  ...filtered.asMap().entries.map((e) {
                    final s = e.value;
                    final statusColor = _statusBg(s['status'] as String);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: StaggerItem(
                        index: e.key + 3,
                        child: GestureDetector(
                          onTap: () => HapticFeedback.mediumImpact(),
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
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 48, height: 48,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00677F),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(s['initials'] as String,
                                              style: const TextStyle(
                                                fontSize: 17, fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(s['name'] as String,
                                              style: const TextStyle(
                                                fontSize: 17, fontWeight: FontWeight.w700,
                                                color: Color(0xFF191C1E))),
                                            const SizedBox(height: 2),
                                            Text(s['class'] as String,
                                              style: const TextStyle(
                                                fontSize: 13, color: Color(0xFF6C797F))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 56, height: 56,
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text('${s['grade']}%',
                                          style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w700,
                                            color: statusColor)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (s['grade'] as int) / 100,
                                    backgroundColor: const Color(0xFFECEEF0),
                                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                    minHeight: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(s['status'] as String,
                                    style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700,
                                      color: statusColor)),
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
}

class _FilterChip extends StatelessWidget {
  final String label; final int count; final bool selected; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00677F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF00677F) : const Color(0xFFBBC9CF),
          ),
        ),
        child: Row(
          children: [
            Text(label,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF3C494E))),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? Colors.white.withOpacity(0.2) : const Color(0xFFECEEF0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count',
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF6C797F))),
            ),
          ],
        ),
      ),
    );
  }
}
