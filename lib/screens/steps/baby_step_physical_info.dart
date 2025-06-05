import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhjaaa/cubits/add_baby/add_baby_cubit.dart';
import 'package:muhjaaa/utils/app_colors.dart';
import 'package:muhjaaa/widgets/custom_text_form_field.dart';

class BabyStepPhysicalInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const BabyStepPhysicalInfo({super.key, required this.formKey});

  @override
  State<BabyStepPhysicalInfo> createState() => _BabyStepPhysicalInfoState();
}

class _BabyStepPhysicalInfoState extends State<BabyStepPhysicalInfo> {
  late TextEditingController _weightController;
  late TextEditingController _lengthController;
  late TextEditingController _bloodTypeController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddBabyCubit>().state;
    _weightController = TextEditingController(
      text: state.babyInfo.weightGm?.toStringAsFixed(0) ?? '',
    );
    _lengthController = TextEditingController(
      text: state.babyInfo.lengthCm?.toStringAsFixed(0) ?? '',
    );
    _bloodTypeController = TextEditingController(
      text: state.babyInfo.bloodType ?? '',
    );

    // Add listeners to update cubit state
    _weightController.addListener(() {
      context.read<AddBabyCubit>().updateWeight(_weightController.text);
    });
    _lengthController.addListener(() {
      context.read<AddBabyCubit>().updateLength(_lengthController.text);
    });
    _bloodTypeController.addListener(() {
      context.read<AddBabyCubit>().updateBloodType(_bloodTypeController.text);
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lengthController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for state changes to potentially update controllers if external changes occur
    // though usually, controllers drive the state.
    final state = context.watch<AddBabyCubit>().state;

    // This is a subtle point: if the cubit state changes from an external source
    // (e.g. loading data), the controllers might need to be updated.
    // However, for simple form input, the listeners usually suffice.
    // For robustness against external state changes for these fields:
    // if (_weightController.text != (state.babyInfo.weightGm?.toStringAsFixed(0) ?? '')) {
    //   _weightController.text = state.babyInfo.weightGm?.toStringAsFixed(0) ?? '';
    // }
    // Similar checks for length and bloodType if needed. But be careful of cursor jumps.

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
                  Icons.monitor_weight_outlined,
                  size: 80,
                  color: AppColors.lightGrey,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _weightController, // Use controller
                    labelText: "الوزن (غم)",
                    hintText: "ادخلي وزن طفلك",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'مطلوب';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null) {
                        return 'رقم غير صالح';
                      }
                      if (weight <= 0) {
                        return 'غير صالح';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: _lengthController, // Use controller
                    labelText: "الطول (سم)",
                    hintText: "ادخلي طول طفلك",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'مطلوب';
                      }
                      final length = double.tryParse(value);
                      if (length == null) {
                        return 'رقم غير صالح';
                      }
                      if (length <= 0) {
                        return 'غير صالح';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: _bloodTypeController, // Use controller
              labelText: "فصيلة الدم",
              hintText: "مثال: A+",
              validator: (value) {
                // Make it optional or add specific validation if needed
                // For example, if it must be A+, A-, B+, B-, AB+, AB-, O+, O-
                // if (value != null && value.isNotEmpty && !RegExp(r'^(A|B|AB|O)[+-]$').hasMatch(value.toUpperCase())) {
                //   return 'صيغة غير صحيحة';
                // }
                return null; // Optional for now
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
