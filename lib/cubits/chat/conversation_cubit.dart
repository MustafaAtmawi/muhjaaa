import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/message_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';
import 'package:muhjaaa/widgets/message_bubble.dart'; // For SenderType

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ChatRepository _chatRepository;
  final String conversationId;

  List<MessageModel> _currentMessages = [];

  ConversationCubit({
    required ChatRepository chatRepository,
    required this.conversationId,
  }) : _chatRepository = chatRepository,
       super(ConversationInitial()) {
    print(
      "[ConversationCubit] Initialized for conversationId: $conversationId",
    );
  }

  Future<void> fetchMessages() async {
    print(
      "[ConversationCubit] fetchMessages: Emitting ConversationLoading for $conversationId",
    );
    emit(ConversationLoading());
    try {
      print(
        "[ConversationCubit] fetchMessages: Calling _chatRepository.getMessages for $conversationId",
      );
      final result = await _chatRepository.getMessages(conversationId);
      print(
        "[ConversationCubit] fetchMessages: Got result from _chatRepository.getMessages for $conversationId",
      );

      result.fold(
        (failure) {
          print(
            "[ConversationCubit] fetchMessages: Fold - Failure: ${failure.message} for $conversationId",
          );
          emit(ConversationError(failure.message, List.from(_currentMessages)));
          print(
            "[ConversationCubit] fetchMessages: Emitted ConversationError for $conversationId",
          );
        },
        (messages) {
          print(
            "[ConversationCubit] fetchMessages: Fold - Success: Received ${messages.length} messages for $conversationId",
          );
          _currentMessages = List.from(messages);
          emit(ConversationLoaded(List.from(_currentMessages)));
          print(
            "[ConversationCubit] fetchMessages: Emitted ConversationLoaded with ${_currentMessages.length} messages for $conversationId",
          );
        },
      );
    } catch (e, stackTrace) {
      print("[ConversationCubit] fetchMessages: CRITICAL ERROR: $e");
      print("[ConversationCubit] fetchMessages: StackTrace: $stackTrace");
      emit(
        ConversationError(
          "Critical error fetching messages: ${e.toString()}",
          List.from(_currentMessages),
        ),
      );
      print(
        "[ConversationCubit] fetchMessages: Emitted ConversationError due to critical error for $conversationId",
      );
    }
  }

  Future<void> sendMessage(String text) async {
    print(
      "[ConversationCubit] sendMessage: Current messages count: ${_currentMessages.length} for $conversationId",
    );
    emit(ConversationSending(List.from(_currentMessages)));
    print(
      "[ConversationCubit] sendMessage: Emitted ConversationSending for $conversationId",
    );

    try {
      final result = await _chatRepository.sendMessage(conversationId, text);
      print(
        "[ConversationCubit] sendMessage: Got result from _chatRepository.sendMessage for $conversationId",
      );

      result.fold(
        (failure) {
          print(
            "[ConversationCubit] sendMessage: Fold - Failure: ${failure.message} for $conversationId",
          );
          emit(ConversationError(failure.message, List.from(_currentMessages)));
          print(
            "[ConversationCubit] sendMessage: Emitted ConversationError for $conversationId",
          );
        },
        (sentMessage) {
          print(
            "[ConversationCubit] sendMessage: Fold - Success: Message sent for $conversationId",
          );
          _currentMessages.add(sentMessage);

          if (conversationId == "ai_mama_chat") {
            print(
              "[ConversationCubit] sendMessage: Adding AI reply for ai_mama_chat",
            );
            final aiReply = MessageModel(
              id: 'ai-reply-${DateTime.now().millisecondsSinceEpoch}',
              text: "فهمتك يا ماما، سأبحث لك عن أفضل النصائح بخصوص: \"$text\"",
              senderType: SenderType.aiMama,
              senderId: 'ai_mama_id',
              timestamp: DateTime.now().add(const Duration(seconds: 1)),
              avatarAssetPath:
                  'assets/images/Ai_Mama.svg', // Ensure this path is correct
            );
            _currentMessages.add(aiReply);
            print(
              "[ConversationCubit] sendMessage: AI reply added for $conversationId",
            );
          }
          emit(ConversationLoaded(List.from(_currentMessages)));
          print(
            "[ConversationCubit] sendMessage: Emitted ConversationLoaded with ${_currentMessages.length} messages for $conversationId",
          );
        },
      );
    } catch (e, stackTrace) {
      print("[ConversationCubit] sendMessage: CRITICAL ERROR: $e");
      print("[ConversationCubit] sendMessage: StackTrace: $stackTrace");
      // Revert to old messages before error if possible, or just show error with current state
      emit(
        ConversationError(
          "Critical error sending message: ${e.toString()}",
          List.from(_currentMessages),
        ),
      );
      print(
        "[ConversationCubit] sendMessage: Emitted ConversationError due to critical error for $conversationId",
      );
    }
  }
}
