import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/add_baby/add_baby_cubit.dart';
import 'package:muhjaaa/screens/steps/baby_step_birth_details.dart';
import 'package:muhjaaa/screens/steps/baby_step_gender_name.dart';
import 'package:muhjaaa/screens/steps/baby_step_physical_info.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/step_indicator.dart';

class AddBabyScreen extends StatefulWidget {
  const AddBabyScreen({super.key});

  @override
  State<AddBabyScreen> createState() => _AddBabyScreenState();
}

class _AddBabyScreenState extends State<AddBabyScreen> {
  final PageController _pageController = PageController();

  // Create a list of GlobalKey<FormState> for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(BuildContext context) {
    final cubit = context.read<AddBabyCubit>();
    // Validate current form before proceeding
    if (_formKeys[cubit.state.currentStep].currentState?.validate() ?? false) {
      cubit.nextStep();
    } else {
      // If validation fails, ensure autovalidateMode is turned on to show errors
      cubit.emit(
        cubit.state.copyWith(
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBabyCubit(),
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        // appBar: AppBar( // No global AppBar shown in design
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: AppColors.darkGreyText),
        //     onPressed: () {
        //        final cubit = context.read<AddBabyCubit>(); // Reading here before BlocListener might be an issue
        //        if (cubit.state.currentStep == 0) {
        //          Navigator.of(context).pop();
        //        } else {
        //          cubit.previousStep();
        //        }
        //     },
        //   ),
        //   title: Text("إضافة معلومات الطفل", style: TextStyle(color: AppColors.darkGreyText, fontFamily: 'Cairo')),
        //   backgroundColor: AppColors.white,
        //   elevation: 0.5,
        // ),
        body: BlocConsumer<AddBabyCubit, AddBabyState>(
          listener: (context, state) {
            if (state.currentStep != _pageController.page?.round()) {
              _pageController.animateToPage(
                state.currentStep,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              if (state.errorMessage == "تم حفظ معلومات الطفل بنجاح!") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.right,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Optionally navigate away or reset form after a delay
                // Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.right,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              // Clear the error message after showing it
              context.read<AddBabyCubit>().emit(
                state.copyWith(clearErrorMessage: true),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (state.currentStep > 0)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.darkGreyText,
                              size: 20,
                            ),
                            onPressed: () =>
                                context.read<AddBabyCubit>().previousStep(),
                          )
                        else
                          // Placeholder for alignment if no back button
                          const SizedBox(width: 1),
                        const Text(
                          "معلومات الطفل", // "baby inf" from design
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreyText,
                          ),
                        ),
                        // Placeholder for alignment or a close button
                      ],
                    ),
                  ),

                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable manual swipe
                      children: <Widget>[
                        BabyStepGenderName(formKey: _formKeys[0]),
                        BabyStepPhysicalInfo(formKey: _formKeys[1]),
                        BabyStepBirthDetails(formKey: _formKeys[2]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      onPressed: () => _onNextPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        state.currentStep ==
                                context.read<AddBabyCubit>().totalSteps - 1
                            ? "حفظ المعلومات"
                            : "التالي",
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
