import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.right,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final FocusNode _focusNode = FocusNode();
  // String? _currentErrorText; // Managed by autovalidateMode

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    // widget.controller.addListener(_onTextChanged); // Not strictly needed with autovalidate
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    // widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {}); // To update floatingLabelStyle color
    }
  }

  // void _onTextChanged() { // Not strictly needed with autovalidate
  //   if (_focusNode.hasFocus) {
  //     _validate();
  //   }
  // }

  // void _validate() { // Managed by autovalidateMode and validator
  //   if (widget.validator != null) {
  //     final error = widget.validator!(widget.controller.text);
  //     if (mounted && _currentErrorText != error) {
  //       setState(() {
  //         _currentErrorText = error;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15.0,
        color: AppColors.darkGreyText,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15.0,
          color: AppColors.lightGrey,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15.0,
          color: AppColors.lightGrey,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: _focusNode.hasFocus
              ? AppColors.primaryRed
              : AppColors.lightGrey,
          fontSize: 17.0,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.redAccent,
          fontSize: 12,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: widget.prefixIcon,
              )
            : null,
        prefixIconConstraints: widget.prefixIcon != null
            ? const BoxConstraints(minWidth: 24, minHeight: 24)
            : const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(
              157,
              189,
              187,
              0.5,
            ), // AppColors.lightGrey.withOpacity(0.5)
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromRGBO(
              157,
              189,
              187,
              0.5,
            ), // AppColors.lightGrey.withOpacity(0.5)
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        floatingLabelBehavior: widget.labelText != null
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
      ),
    );
  }
}
