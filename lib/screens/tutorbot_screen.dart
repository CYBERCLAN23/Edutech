import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/providers/chat_provider.dart';
import 'package:educam_ai/models/chat_message.dart';
import 'package:educam_ai/widgets/ai_avatar.dart';
import 'package:educam_ai/widgets/chat_bubble.dart';

class TutorBotScreen extends ConsumerStatefulWidget {
  const TutorBotScreen({super.key});

  @override
  ConsumerState<TutorBotScreen> createState() => TutorBotScreenState();
}

class TutorBotScreenState extends ConsumerState<TutorBotScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider.notifier).loadHistory();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage([String? text]) {
    final message = text ?? textController.text.trim();
    if (message.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(message);
    textController.clear();
    _scrollToBottom();
  }

  void _selectSubject(String subject) {
    sendMessage('Je suis en $subject. Peux-tu m\'aider à réviser cette matière ?');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _ChatAppBar(),
            Expanded(
              child: messages.isEmpty
                  ? _WelcomeContent(
                      onSubjectTap: _selectSubject,
                      onSuggestedTap: sendMessage,
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final msg = messages[index];
                        if (msg.isLoading) {
                          return const LoadingBubble();
                        }
                        return ChatBubble(
                          message: msg.content,
                          isUser: msg.isUser,
                        );
                      },
                    ),
            ),
            _ChatInputBar(
              controller: textController,
              onSend: () => sendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  const _ChatAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        boxShadow: EduCamTheme.softShadow,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.arrow_back_rounded, color: EduCamColors.primary, size: 22),
            ),
          ),
          const AiAvatar(size: 40),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TutorBot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary)),
              Text('En ligne - accompagnement AI', style: TextStyle(fontSize: 11, color: EduCamColors.success, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: EduCamColors.secondaryText),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  final void Function(String subject) onSubjectTap;
  final void Function(String question) onSuggestedTap;

  const _WelcomeContent({
    required this.onSubjectTap,
    required this.onSuggestedTap,
  });

  static const _subjects = [
    ('Maths', Icons.functions, EduCamColors.subjectMaths),
    ('SVT', Icons.biotech, EduCamColors.subjectSVT),
    ('Physique-Chimie', Icons.science, EduCamColors.subjectPhysique),
    ('Histoire', Icons.history_edu, EduCamColors.subjectHistoire),
    ('Français', Icons.abc, EduCamColors.subjectFrancais),
    ('Anglais', Icons.language, EduCamColors.subjectAnglais),
  ];

  static const _suggestedQuestions = [
    'Explique-moi un concept scientifique',
    'Propose-moi un exercice',
    'Comment rédiger une dissertation ?',
    'Conseils pour le BAC',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const AiAvatar(size: 56),
          const SizedBox(height: 16),
          const Text(
            'Salut ! Je suis TutorBot, ton compagnon d\'apprentissage IA.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: EduCamColors.primary, height: 1.3),
          ),
          const SizedBox(height: 8),
          const Text(
            'Je peux t\'aider en Maths, SVT, Physique-Chimie, Histoire, Français et Anglais.\n\n'
            'Choisis une matière ou pose-moi une question directement !',
            style: TextStyle(fontSize: 15, color: EduCamColors.secondaryText, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Matières',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _buildSubjectChips(),
          ),
          const SizedBox(height: 28),
          const Text(
            'Suggestions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EduCamColors.primary),
          ),
          const SizedBox(height: 12),
          ..._buildSuggestedChips(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildSubjectChips() {
    return _subjects.map((s) {
      final name = s.$1;
      final icon = s.$2;
      final color = s.$3;
      return ActionChip(
        avatar: Icon(icon, size: 18, color: color),
        label: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        backgroundColor: color.withOpacity(0.08),
        onPressed: () => onSubjectTap(name),
      );
    }).toList();
  }

  List<Widget> _buildSuggestedChips() {
    return _suggestedQuestions.map((q) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => onSuggestedTap(q),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: EduCamColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EduCamColors.cardBorder),
              boxShadow: EduCamTheme.softShadow,
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: EduCamColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(q, style: const TextStyle(fontSize: 14, color: EduCamColors.primary)),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: EduCamColors.surface,
        boxShadow: EduCamTheme.softShadow,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: EduCamColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic_rounded, color: EduCamColors.accent, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Pose ta question ici...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontSize: 15, color: EduCamColors.primary),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [EduCamColors.accent, Color(0xFF7C3AED)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
