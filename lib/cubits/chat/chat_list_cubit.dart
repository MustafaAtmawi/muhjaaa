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
    // Print statements can be helpful during debugging. You can remove them later.
    print("ChatListCubit (Original): Emitting ChatListLoading");
    emit(ChatListLoading());
    try {
      print("ChatListCubit (Original): Fetching chat previews...");
      final previewsResult = await _chatRepository.getChatPreviews();
      print(
        "ChatListCubit (Original): Fetched chat previews. Success: ${previewsResult.isRight}",
      );

      print("ChatListCubit (Original): Fetching active doctors...");
      final doctorsResult = await _chatRepository.getActiveDoctors();
      print(
        "ChatListCubit (Original): Fetched active doctors. Success: ${doctorsResult.isRight}",
      );

      List<ChatPreviewModel> previews = [];
      List<DoctorModel> doctors = [];
      String? failureMessage;

      previewsResult.fold(
        (failure) {
          print(
            "ChatListCubit (Original): Previews failed - ${failure.message}",
          );
          failureMessage = failure.message;
        },
        (data) {
          print(
            "ChatListCubit (Original): Previews success - ${data.length} items",
          );
          previews = data;
        },
      );

      if (failureMessage != null) {
        print(
          "ChatListCubit (Original): Emitting ChatListFailure due to previewsResult: $failureMessage",
        );
        emit(ChatListFailure(failureMessage!));
        return;
      }

      doctorsResult.fold(
        (failure) {
          print(
            "ChatListCubit (Original): Doctors failed - ${failure.message}",
          );
          failureMessage = failure.message;
        },
        (data) {
          print(
            "ChatListCubit (Original): Doctors success - ${data.length} items",
          );
          doctors = data;
        },
      );

      if (failureMessage != null) {
        print(
          "ChatListCubit (Original): Emitting ChatListFailure due to doctorsResult: $failureMessage",
        );
        emit(ChatListFailure(failureMessage!));
        return;
      }

      print(
        "ChatListCubit (Original): Emitting ChatListLoaded with ${previews.length} previews and ${doctors.length} doctors.",
      );
      emit(ChatListLoaded(chatPreviews: previews, activeDoctors: doctors));
    } catch (e) {
      print(
        "ChatListCubit (Original): Caught error: $e. Emitting ChatListFailure.",
      );
      emit(ChatListFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
