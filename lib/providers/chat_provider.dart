import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/models/chat_message.dart';
import 'package:educam_ai/services/ai_service.dart';

final aiServiceProvider = Provider<AiService>((ref) => AiService());

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref.read(aiServiceProvider));
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final AiService _ai;

  ChatNotifier(this._ai) : super([]);

  Future<void> loadHistory() async {
    try {
      final history = await _ai.getChatHistory();
      state = history.map((m) => ChatMessage(
        id: m['id'] as String,
        content: m['content'] as String,
        isUser: !(m['is_ai'] as bool),
        timestamp: DateTime.parse(m['created_at'] as String),
      )).toList();
    } catch (_) {}
  }

  Future<void> sendMessage(String content) async {
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    final loadingMsg = ChatMessage(
      id: 'loading-${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    state = [...state, userMsg, loadingMsg];

    try {
      final reply = await _ai.chat(content);
      state = [
        ...state.where((m) => !m.isLoading),
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    } catch (e) {
      state = [
        ...state.where((m) => !m.isLoading),
        ChatMessage(
          id: 'error-${DateTime.now().millisecondsSinceEpoch}',
          content: 'Désolé, je n\'ai pas pu répondre. Vérifie ta connexion et réessaie.',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      ];
    }
  }
}
