import 'package:flutter_bloc/flutter_bloc.dart'; // CHANGED IMPORT
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/widgets/message_bubble.dart'; // ADDED for SenderType

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ChatRepository _chatRepository;
  final String conversationId;

  List<MessageModel> _currentMessages = [];

  ConversationCubit({
    required ChatRepository chatRepository,
    required this.conversationId,
  }) : _chatRepository = chatRepository,
       super(ConversationInitial());

  Future<void> fetchMessages() async {
    emit(ConversationLoading());
    final result = await _chatRepository.getMessages(conversationId);
    result.fold(
      (failure) {
        emit(ConversationError(failure.message, _currentMessages));
      },
      (messages) {
        _currentMessages = messages;
        emit(ConversationLoaded(messages));
      },
    );
  }

  Future<void> sendMessage(String text) async {
    emit(ConversationSending(List.from(_currentMessages)));

    final result = await _chatRepository.sendMessage(conversationId, text);

    result.fold(
      (failure) {
        emit(ConversationError(failure.message, List.from(_currentMessages)));
      },
      (sentMessage) {
        _currentMessages.add(sentMessage);

        if (conversationId == "ai_mama_chat") {
          final aiReply = MessageModel(
            id: 'ai-reply-${DateTime.now().millisecondsSinceEpoch}',
            text: "فهمتك يا ماما، سأبحث لك عن أفضل النصائح بخصوص: \"$text\"",
            senderType: SenderType.aiMama,
            senderId: 'ai_mama_id',
            timestamp: DateTime.now().add(const Duration(seconds: 1)),
            avatarAssetPath: 'assets/images/AI_mama.png',
          );
          _currentMessages.add(aiReply);
        }
        emit(ConversationLoaded(List.from(_currentMessages)));
      },
    );
  }
}
