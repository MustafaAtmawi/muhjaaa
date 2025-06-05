import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/add_baby/add_baby_cubit.dart';
import 'package:muhjaaa/models/baby_info_model.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class BabyStepGenderName extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const BabyStepGenderName({super.key, required this.formKey});

  @override
  State<BabyStepGenderName> createState() => _BabyStepGenderNameState();
}

class _BabyStepGenderNameState extends State<BabyStepGenderName> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final initialName = context.read<AddBabyCubit>().state.babyInfo.name;
    _nameController = TextEditingController(text: initialName);

    _nameController.addListener(() {
      // To avoid issues if the cubit updates the name for other reasons,
      // only update if the controller's text is different from the cubit's state.
      // However, for simple input, this direct update is common.
      if (context.read<AddBabyCubit>().state.babyInfo.name !=
          _nameController.text) {
        context.read<AddBabyCubit>().updateName(_nameController.text);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context
        .read<
          AddBabyCubit
        >(); // Can be read if only used for dispatching actions
    final state = context
        .watch<AddBabyCubit>()
        .state; // Use watch for reactive UI updates

    // This ensures that if the state in the cubit changes (e.g. by navigating back and forth
    // and the cubit had a different name initially), the text field reflects it.
    // Be careful with cursor position if text is updated while user is typing.
    // This is usually more relevant if the state can change from sources other than this field.
    // For simple forms, the initState and listener might be enough.
    // However, if another part of the UI could change babyInfo.name, this syncs it back.
    // Consider if this exact logic is needed or if initState and listener are sufficient.
    // If the cubit's state is the source of truth and might change, this is one way to sync.
    // A simpler approach for forms is often to let the controller be the source of truth for the field,
    // and only update the cubit via the listener.
    // For this fix, we'll keep it simple: initState sets initial text, listener updates cubit.
    // If navigating back to this step and state.babyInfo.name changed elsewhere, this won't reflect.
    // A more robust solution for two-way binding might use didUpdateWidget or listen to cubit changes here.
    //
    // Let's ensure controller reflects state if widget rebuilds with different state.name (e.g. back navigation)
    // This requires careful handling to avoid infinite loops or losing cursor.
    // A common pattern is to only update the controller if the incoming state value is different AND the field isn't focused.
    // For simplicity and common case where cubit is updated primarily by this field's listener:
    // The current _nameController.text would be the most up-to-date from user input.
    // The listener already updates the cubit.
    // If navigating back, initState will set the text from cubit.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: widget.formKey,
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
                  Icons.child_care,
                  size: 80,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
            const Text(
              "الجنس",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreyText,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _GenderButton(
                    label: "أنثى",
                    isSelected: state.babyInfo.gender == Gender.female,
                    onTap: () => cubit.updateGender(Gender.female),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GenderButton(
                    label: "ذكر",
                    isSelected: state.babyInfo.gender == Gender.male,
                    onTap: () => cubit.updateGender(Gender.male),
                  ),
                ),
              ],
            ),
            if (state.autovalidateMode != AutovalidateMode.disabled &&
                state.babyInfo.gender == Gender.unknown)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                child: Text(
                  'الرجاء اختيار الجنس',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            CustomTextFormField(
              controller: _nameController, // Use the managed controller
              labelText: "اسم الطفل",
              hintText: "ادخلي اسم طفلك",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم الطفل';
                }
                if (value.length < 2) {
                  return 'يجب أن يكون الاسم حرفين على الأقل';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primaryRed : AppColors.white,
        foregroundColor: isSelected ? AppColors.white : AppColors.primaryRed,
        side: BorderSide(
          color: AppColors.primaryRed,
          width: isSelected ? 0 : 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: isSelected ? 2 : 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
