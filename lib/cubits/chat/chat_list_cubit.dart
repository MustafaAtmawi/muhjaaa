import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muhjaaa/models/chat_preview_model.dart';
import 'package:muhjaaa/models/doctor_model.dart';
import 'package:muhjaaa/repositories/chat_repository.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository _chatRepository;

  ChatListCubit({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatListInitial());

  Future<void> fetchChatListData() async {
    emit(ChatListLoading());
    try {
      final previewsResult = await _chatRepository.getChatPreviews();
      final doctorsResult = await _chatRepository.getActiveDoctors();

      List<ChatPreviewModel> previews = [];
      List<DoctorModel> doctors = [];
      String? failureMessage;

      previewsResult.fold(
        (failure) {
          failureMessage = failure.message;
        },
        (data) {
          previews = data;
        },
      );

      if (failureMessage != null) {
        emit(ChatListFailure(failureMessage!));
        return;
      }

      doctorsResult.fold(
        (failure) {
          failureMessage = failure.message;
        },
        (data) {
          doctors = data;
        },
      );

      if (failureMessage != null) {
        emit(ChatListFailure(failureMessage!));
        return;
      }
      emit(ChatListLoaded(chatPreviews: previews, activeDoctors: doctors));
    } catch (e) {
      emit(ChatListFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
