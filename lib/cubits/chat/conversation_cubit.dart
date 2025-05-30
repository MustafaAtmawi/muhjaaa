import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ChatRepository _chatRepository;
  final String
  conversationId; // To know which conversation this cubit instance is for

  List<MessageModel> _currentMessages = []; // Internal cache

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
    // Optimistically add the user's message to the UI
    // This will be replaced/confirmed by the backend response in a real app
    // For now, our mock repository returns the sent message.

    // final optimisticMessage = MessageModel(
    //   id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
    //   text: text,
    //   senderType: SenderType.me, // Assuming SenderType is accessible or defined
    //   senderId: 'current_user_id_placeholder', // Replace with actual current user ID
    //   timestamp: DateTime.now(),
    //   avatarInitial: 'أ', // User's initial
    // );
    // _currentMessages.add(optimisticMessage);
    // emit(ConversationSending(List.from(_currentMessages))); // Show optimistic update

    // Keep current messages visible while sending
    emit(ConversationSending(List.from(_currentMessages)));

    final result = await _chatRepository.sendMessage(conversationId, text);

    result.fold(
      (failure) {
        // Remove optimistic message if sending failed, or handle error appropriately
        // _currentMessages.remove(optimisticMessage);
        emit(ConversationError(failure.message, List.from(_currentMessages)));
      },
      (sentMessage) {
        // Add the confirmed message from the repository
        // If your backend returns the sent message, you can update the list
        // If not, you might just refetch or assume success based on HTTP status
        _currentMessages.add(sentMessage);

        // If the AI is expected to reply, you might get another message here
        // For AI Mama, simulate a reply
        if (conversationId == "ai_mama_chat") {
          // This is a simplified simulation. In a real app, the AI response
          // would come from the backend after processing the user's message.
          // You might have a separate mechanism or a follow-up call to get the AI reply.
          final aiReply = MessageModel(
            id: 'ai-reply-${DateTime.now().millisecondsSinceEpoch}',
            text: "فهمتك يا ماما، سأبحث لك عن أفضل النصائح بخصوص: \"$text\"",
            senderType:
                SenderType.aiMama, // Make sure SenderType is imported/available
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
