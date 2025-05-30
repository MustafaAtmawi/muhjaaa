part of 'conversation_cubit.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<MessageModel> messages;

  const ConversationLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ConversationSending extends ConversationState {
  final List<MessageModel>
  messages; // Keep showing existing messages while sending
  const ConversationSending(this.messages);
  @override
  List<Object> get props => [messages];
}

// We might not need a specific SendSuccess state if we just update ConversationLoaded
// class ConversationSendSuccess extends ConversationState {
//   final List<MessageModel> messages;
//   const ConversationSendSuccess(this.messages);
//   @override
//   List<Object> get props => [messages];
// }

class ConversationError extends ConversationState {
  final String message;
  final List<MessageModel>
  previousMessages; // To still display old messages on error

  const ConversationError(this.message, this.previousMessages);

  @override
  List<Object> get props => [message, previousMessages];
}
