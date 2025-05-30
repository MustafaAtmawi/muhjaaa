part of 'chat_list_cubit.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatPreviewModel> chatPreviews;
  final List<DoctorModel> activeDoctors;

  const ChatListLoaded({
    required this.chatPreviews,
    required this.activeDoctors,
  });

  @override
  List<Object> get props => [chatPreviews, activeDoctors];
}

class ChatListFailure extends ChatListState {
  final String message;

  const ChatListFailure(this.message);

  @override
  List<Object> get props => [message];
}
