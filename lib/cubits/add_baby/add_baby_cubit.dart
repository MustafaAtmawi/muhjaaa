import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For AutovalidateMode
import 'package:muhjaaa/models/baby_info_model.dart';

part 'add_baby_state.dart';

class AddBabyCubit extends Cubit<AddBabyState> {
  AddBabyCubit() : super(const AddBabyState());

  final int totalSteps = 3;

  void updateName(String name) {
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(name: name),
        clearErrorMessage: true,
      ),
    );
  }

  void updateGender(Gender gender) {
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(gender: gender),
        clearErrorMessage: true,
      ),
    );
  }

  void updateLength(String length) {
    final double? lengthCm = double.tryParse(length);
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(lengthCm: lengthCm),
        clearErrorMessage: true,
      ),
    );
  }

  void updateWeight(String weight) {
    final double? weightGm = double.tryParse(weight);
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(weightGm: weightGm),
        clearErrorMessage: true,
      ),
    );
  }

  void updateBloodType(String bloodType) {
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(bloodType: bloodType),
        clearErrorMessage: true,
      ),
    );
  }

  void updateBirthDate(DateTime birthDate) {
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(birthDate: birthDate),
        clearErrorMessage: true,
      ),
    );
  }

  void toggleSpecialCondition(bool hasCondition) {
    emit(
      state.copyWith(
        babyInfo: state.babyInfo.copyWith(hasSpecialCondition: hasCondition),
        clearErrorMessage: true,
      ),
    );
  }

  void nextStep() {
    // Enable validation on attempting to go next
    emit(state.copyWith(autovalidateMode: AutovalidateMode.onUserInteraction));

    // Add validation logic per step here if needed
    bool canProceed = true;
    if (state.currentStep == 0) {
      if (state.babyInfo.gender == Gender.unknown ||
          state.babyInfo.name.isEmpty) {
        canProceed = false;
        emit(state.copyWith(errorMessage: "الرجاء إكمال جميع الحقول"));
      }
    } else if (state.currentStep == 1) {
      // Basic check, more specific validation (e.g. numeric) should be in TextFormFields
      if (state.babyInfo.lengthCm == null ||
          state.babyInfo.weightGm == null ||
          state.babyInfo.bloodType == null ||
          state.babyInfo.bloodType!.isEmpty) {
        canProceed = false;
        emit(state.copyWith(errorMessage: "الرجاء إكمال جميع الحقول"));
      }
    } else if (state.currentStep == 2) {
      if (state.babyInfo.birthDate == null) {
        canProceed = false;
        emit(state.copyWith(errorMessage: "الرجاء إدخال تاريخ الميلاد"));
      }
    }

    if (canProceed && state.currentStep < totalSteps - 1) {
      emit(
        state.copyWith(
          currentStep: state.currentStep + 1,
          autovalidateMode: AutovalidateMode.disabled, // Reset for next step
          clearErrorMessage: true,
        ),
      );
    } else if (canProceed && state.currentStep == totalSteps - 1) {
      // This is the final step, attempt to submit data
      submitBabyInfo();
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(
        state.copyWith(
          currentStep: state.currentStep - 1,
          autovalidateMode: AutovalidateMode.disabled, // Reset validation mode
          clearErrorMessage: true,
        ),
      );
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      // Usually, you'd only allow forward progression after validation
      // For direct jump, consider implications or restrict it.
      // For now, basic jump:
      emit(
        state.copyWith(
          currentStep: step,
          autovalidateMode: AutovalidateMode.disabled,
          clearErrorMessage: true,
        ),
      );
    }
  }

  Future<void> submitBabyInfo() async {
    // Perform final validation if any
    if (state.babyInfo.gender == Gender.unknown ||
        state.babyInfo.name.isEmpty ||
        state.babyInfo.lengthCm == null ||
        state.babyInfo.weightGm == null ||
        // state.babyInfo.bloodType == null || // Blood type might be optional
        state.babyInfo.birthDate == null) {
      emit(
        state.copyWith(
          errorMessage: "الرجاء التأكد من إكمال جميع الحقول المطلوبة.",
        ),
      );
      return;
    }

    emit(
      state.copyWith(clearErrorMessage: true),
    ); // Indicate loading if async op
    // Simulate API call or saving to repository
    // print("Submitting Baby Info: ${state.babyInfo}");
    // await Future.delayed(const Duration(seconds: 1));

    // In a real app, you'd handle success/failure from a repository
    // For now, let's assume success and potentially navigate away or show a message.
    // This might involve emitting a new state like AddBabySuccess or AddBabyFailure.
    // Or, navigation can be handled by a BlocListener in the UI.
    // For this example, let's just emit a success message.
    emit(state.copyWith(errorMessage: "تم حفظ معلومات الطفل بنجاح!"));
    // Potentially reset to initial state or navigate after success.
  }
}
