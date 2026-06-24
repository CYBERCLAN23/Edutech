import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/providers/auth_provider.dart';
import 'package:educam_ai/services/auth_service.dart';
import 'package:educam_ai/services/cache_service.dart';
import 'package:educam_ai/screens/main_shell.dart';
import 'package:educam_ai/widgets/stagger_item.dart';

class RoleSelectScreen extends ConsumerStatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  ConsumerState<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends ConsumerState<RoleSelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bgFade;
  late Animation<Offset> _titleSlide;

  bool _showLogin = false;
  bool _isLogin = true;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String? _selectedRole;
  String _selectedClass = 'Terminale C';
  bool _obscurePassword = true;

  final _classes = ['Terminale C', 'Terminale D', 'Premiere C', 'Seconde C'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_isLogin && _nameCtrl.text.trim().isEmpty) return;
    if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.trim().isEmpty) return;

    final notifier = ref.read(authStateProvider.notifier);
    if (_isLogin) {
      await notifier.login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    } else {
      await notifier.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        role: _selectedRole ?? 'student',
        className: _selectedRole == 'student' ? _selectedClass : null,
      );
    }

    final authState = ref.read(authStateProvider);
    if (authState.status == AuthStatus.authenticated) {
      await CacheService().saveToken(AuthService().token ?? '');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    }
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      _showLogin = true;
      _isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final error = authState.error;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [EduCamColors.surface, Color(0xFFF0EFFA)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _showLogin
                      ? _buildAuthForm(isLoading, error)
                      : _buildRoleSelection(),
                ),
              ),
              if (_showLogin)
                Positioned(
                  top: 8, left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _showLogin = false),
                  ),
                ),
              if (isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRoleSelection() {
    return [
      const SizedBox(height: 60),
      SlideTransition(
        position: _titleSlide,
        child: FadeTransition(
          opacity: _bgFade,
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: EduCamColors.primary, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.auto_stories, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text('Bienvenue sur EduCam AI', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: EduCamColors.primary)),
              const SizedBox(height: 8),
              Text('Choisis ton profil', style: GoogleFonts.poppins(fontSize: 16, color: EduCamColors.secondaryText)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 48),
      StaggerItem(
        index: 0,
        child: _RoleCard(
          icon: Icons.school,
          title: 'Élève',
          subtitle: 'Apprends avec TutorBot, corrige tes copies, prépare tes examens',
          color: EduCamColors.accent,
          onTap: () => _selectRole('student'),
        ),
      ),
      const SizedBox(height: 16),
      StaggerItem(
        index: 1,
        child: _RoleCard(
          icon: Icons.person_outline,
          title: 'Professeur',
          subtitle: 'Gère tes cours, suis tes élèves, génère du contenu avec l\'IA',
          color: EduCamColors.primary,
          onTap: () => _selectRole('teacher'),
        ),
      ),
      const SizedBox(height: 60),
    ];
  }

  List<Widget> _buildAuthForm(bool isLoading, String? error) {
    return [
      const SizedBox(height: 80),
      Text(
        _isLogin ? 'Connexion' : 'Créer un compte ${_selectedRole == 'teacher' ? 'enseignant' : 'élève'}',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: EduCamColors.primary),
      ),
      const SizedBox(height: 32),
      if (!_isLogin) ...[
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(labelText: 'Nom complet', prefixIcon: Icon(Icons.person)),
        ),
        const SizedBox(height: 16),
        if (_selectedRole == 'student')
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Classe', prefixIcon: Icon(Icons.class_)),
            value: _selectedClass,
            items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedClass = v ?? 'Terminale C'),
          ),
        const SizedBox(height: 16),
      ],
      TextField(
        controller: _emailCtrl,
        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _passwordCtrl,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Mot de passe',
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ),
      if (error != null) ...[
        const SizedBox(height: 16),
        Text(error, style: const TextStyle(color: Colors.red, fontSize: 13)),
      ],
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity, height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedRole == 'teacher' ? EduCamColors.primary : EduCamColors.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(_isLogin ? 'Se connecter' : 'Créer mon compte', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: () => setState(() { _isLogin = !_isLogin; }),
        child: Text(_isLogin ? 'Pas encore de compte ? S\'inscrire' : 'Déjà un compte ? Se connecter'),
      ),
    ];
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: EduCamColors.secondaryText)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: EduCamColors.secondaryText, size: 16),
          ],
        ),
      ),
    );
  }
}
