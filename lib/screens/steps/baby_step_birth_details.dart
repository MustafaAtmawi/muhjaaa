import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/add_baby/add_baby_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
// You might need to format the date, consider the intl package if not already used,
// but for basic formatting, we can do it manually.
// For this example, I'll format it as yyyy-MM-dd.

class BabyStepBirthDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const BabyStepBirthDetails({super.key, required this.formKey});

  Future<void> _selectDate(BuildContext context) async {
    final cubit = context.read<AddBabyCubit>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.state.babyInfo.birthDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5), // Max 5 years ago
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.darkGreyText, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != cubit.state.babyInfo.birthDate) {
      cubit.updateBirthDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddBabyCubit>();
    final state = context.watch<AddBabyCubit>().state;

    String displayDate = "ادخلي تاريخ الميلاد";
    if (state.babyInfo.birthDate != null) {
      // Simple formatting: YYYY-MM-DD
      displayDate =
          "${state.babyInfo.birthDate!.year.toString()}-${state.babyInfo.birthDate!.month.toString().padLeft(2, '0')}-${state.babyInfo.birthDate!.day.toString().padLeft(2, '0')}";
      // As per design: "Jan 18, 2025" - this needs intl or more complex formatting
      // For now, I'll use a simpler one. The design might be a static placeholder.
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        autovalidateMode: state.autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Placeholder for Illustration
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.cake_outlined,
                  size: 80,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
            const Text(
              "تاريخ الميلاد",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreyText,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: AppColors.lightGrey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.lightGrey,
                      size: 20,
                    ),
                    Text(
                      displayDate,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15.0,
                        color: state.babyInfo.birthDate != null
                            ? AppColors.darkGreyText
                            : AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.autovalidateMode != AutovalidateMode.disabled &&
                state.babyInfo.birthDate == null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                child: Text(
                  'الرجاء اختيار تاريخ الميلاد',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: state.babyInfo.hasSpecialCondition,
                  onChanged: (value) => cubit.toggleSpecialCondition(value),
                  activeColor: AppColors.primaryRed,
                  inactiveThumbColor: AppColors.lightGrey,
                ),
                const Text(
                  "هل لديه حالة صحية خاصة؟",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: AppColors.darkGreyText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
