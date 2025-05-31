import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/message_model.dart'; // For SenderType and MessageModel
import 'package:muhjaaa/repositories/chat_repository.dart';

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
    try {
      final result = await _chatRepository.getMessages(conversationId);

      result.fold(
        (failure) {
          emit(ConversationError(failure.message, List.from(_currentMessages)));
        },
        (messages) {
          _currentMessages = List.from(messages);
          emit(ConversationLoaded(List.from(_currentMessages)));
        },
      );
    } catch (e) {
      emit(
        ConversationError(
          "Critical error fetching messages: ${e.toString()}",
          List.from(_currentMessages),
        ),
      );
    }
  }

  Future<void> sendMessage(String text) async {
    // Optimistically emit current messages before sending state for smoother UI
    final List<MessageModel> optimisticMessages = List.from(_currentMessages);
    // You could even add the user's message optimistically here if your UI requires it immediately
    // before the ConversationSending state is processed by the UI.
    // For example:
    // final tempUserMessage = MessageModel(id: 'temp', text: text, senderType: SenderType.me, senderId: 'currentUser', timestamp: DateTime.now());
    // optimisticMessages.add(tempUserMessage);

    emit(ConversationSending(optimisticMessages));

    try {
      final result = await _chatRepository.sendMessage(conversationId, text);

      result.fold(
        (failure) {
          // If send fails, revert to messages before optimistic update, or just show error with current state
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
              avatarAssetPath: 'assets/images/Ai_Mama.svg',
            );
            _currentMessages.add(aiReply);
          }
          emit(ConversationLoaded(List.from(_currentMessages)));
        },
      );
    } catch (e) {
      emit(
        ConversationError(
          "Critical error sending message: ${e.toString()}",
          List.from(_currentMessages), // Show messages before the error
        ),
      );
    }
  }
}
