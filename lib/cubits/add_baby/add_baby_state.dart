part of 'add_baby_cubit.dart';

class AddBabyState extends Equatable {
  final BabyInfoModel babyInfo;
  final int currentStep;
  final AutovalidateMode autovalidateMode;
  final String? errorMessage; // For general errors or success messages

  const AddBabyState({
    this.babyInfo = const BabyInfoModel(),
    this.currentStep = 0, // 0-indexed
    this.autovalidateMode = AutovalidateMode.disabled,
    this.errorMessage,
  });

  AddBabyState copyWith({
    BabyInfoModel? babyInfo,
    int? currentStep,
    AutovalidateMode? autovalidateMode,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddBabyState(
      babyInfo: babyInfo ?? this.babyInfo,
      currentStep: currentStep ?? this.currentStep,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    babyInfo,
    currentStep,
    autovalidateMode,
    errorMessage,
  ];
}
