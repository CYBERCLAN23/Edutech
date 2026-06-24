import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class StudentAssignments extends StatefulWidget {
  const StudentAssignments({super.key});

  @override
  State<StudentAssignments> createState() => _StudentAssignmentsState();
}

class _StudentAssignmentsState extends State<StudentAssignments> {
  String _filter = 'All';

  final _tasks = <Map<String, dynamic>>[
    {'title': 'Linear Equations Worksheet', 'subject': 'Mathematics', 'due': 'Tomorrow', 'status': 'Pending', 'color': const Color(0xFF055DB6), 'desc': 'Solve equations 1-20'},
    {'title': 'Cell Structure Diagram', 'subject': 'SVT / Biology', 'due': 'In 3 Days', 'status': 'In Progress', 'color': const Color(0xFF406900), 'desc': 'Label organelles'},
    {'title': 'Newton\'s Laws Essay', 'subject': 'Physics', 'due': 'In 1 Week', 'status': 'Completed', 'color': const Color(0xFF00677F), 'desc': '500 word report'},
    {'title': 'Chemical Reactions Lab', 'subject': 'Chemistry', 'due': 'In 2 Days', 'status': 'Pending', 'color': const Color(0xFF8F5E00), 'desc': 'Write lab report'},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _tasks;
    return _tasks.where((t) => t['status'] == _filter).toList();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Pending': return const Color(0xFFC77D00);
      case 'In Progress': return const Color(0xFF055DB6);
      case 'Completed': return const Color(0xFF406900);
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
                  children: [
                    const Text('My Assignments',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
                    const SizedBox(height: 4),
                    Text('${_tasks.length} assignments this week',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF3C494E))),
                  ],
                )),
                const SizedBox(height: 8),
                StaggerItem(index: 1, child: Row(
                  children: [
                    _StatusChip(label: 'All', count: _tasks.length, selected: _filter == 'All', onTap: () => setState(() => _filter = 'All')),
                    const SizedBox(width: 8),
                    _StatusChip(label: 'Pending', count: _tasks.where((t) => t['status'] == 'Pending').length, selected: _filter == 'Pending', onTap: () => setState(() => _filter = 'Pending')),
                    const SizedBox(width: 8),
                    _StatusChip(label: 'In Progress', count: _tasks.where((t) => t['status'] == 'In Progress').length, selected: _filter == 'In Progress', onTap: () => setState(() => _filter = 'In Progress')),
                    const SizedBox(width: 8),
                    _StatusChip(label: 'Completed', count: _tasks.where((t) => t['status'] == 'Completed').length, selected: _filter == 'Completed', onTap: () => setState(() => _filter = 'Completed')),
                  ],
                )),
                const SizedBox(height: 20),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.task_alt, size: 56, color: const Color(0xFF6C797F).withOpacity(0.3)),
                          const SizedBox(height: 12),
                          const Text('No assignments in this category',
                            style: TextStyle(fontSize: 15, color: Color(0xFF3C494E))),
                        ],
                      ),
                    ),
                  )
                else
                  ...filtered.asMap().entries.map((e) {
                    final t = e.value;
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
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(t['status'] as String).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(t['status'] as String,
                                        style: TextStyle(
                                          fontSize: 11, fontWeight: FontWeight.w700,
                                          color: _statusColor(t['status'] as String))),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, size: 14,
                                          color: (t['status'] as String) == 'Completed'
                                            ? const Color(0xFF406900) : const Color(0xFFC77D00)),
                                        const SizedBox(width: 4),
                                        Text(t['due'] as String,
                                          style: TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w500,
                                            color: (t['status'] as String) == 'Completed'
                                              ? const Color(0xFF406900) : const Color(0xFFC77D00))),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(t['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700,
                                    color: Color(0xFF191C1E))),
                                const SizedBox(height: 4),
                                Text(t['desc'] as String,
                                  style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF3C494E))),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECEEF0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(t['subject'] as String,
                                    style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700,
                                      color: Color(0xFF6C797F))),
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

class _StatusChip extends StatelessWidget {
  final String label; final int count; final bool selected; final VoidCallback onTap;
  const _StatusChip({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
