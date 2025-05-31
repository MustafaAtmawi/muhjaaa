import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText; // Made labelText optional
  final String? hintText; // Added hintText
  final Widget? prefixIcon; // Made prefixIcon optional
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
    this.labelText, // Now optional
    this.hintText, // New
    this.prefixIcon, // Now optional
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
  String? _currentErrorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      if (mounted && _currentErrorText != null) {
        // setState(() {
        //   _currentErrorText = null; // Option: Clear live error on blur
        // });
      }
    } else {
      _validate();
    }
    if (mounted) {
      // Ensure floating label color updates on focus change
      setState(() {});
    }
  }

  void _onTextChanged() {
    if (_focusNode.hasFocus) {
      _validate();
    }
  }

  void _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      if (mounted && _currentErrorText != error) {
        setState(() {
          _currentErrorText = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      // Use validator for form-level validation, errorText for live feedback
      validator: widget.validator,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Validate on interaction
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 15.0, // Matched to design
        color: AppColors.darkGreyText,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText, // Use labelText if provided
        hintText: widget.hintText, // Use hintText if provided
        labelStyle: const TextStyle(
          // Style for floating label
          fontFamily: 'Cairo',
          fontSize: 15.0,
          color: AppColors.lightGrey,
        ),
        hintStyle: const TextStyle(
          // Style for hint text when field is empty
          fontFamily: 'Cairo',
          fontSize: 15.0,
          color: AppColors.lightGrey,
        ),
        floatingLabelStyle: TextStyle(
          // Style for label when it floats (field has focus or text)
          fontFamily: 'Cairo',
          color: _focusNode.hasFocus
              ? AppColors.primaryRed
              : AppColors.lightGrey,
          fontSize: 17.0, // Slightly larger when floating
        ),
        // errorText: _currentErrorText, // Using autovalidate mode handles this better
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
            : null, // Only add padding if prefixIcon exists
        prefixIconConstraints: widget.prefixIcon != null
            ? const BoxConstraints(minWidth: 24, minHeight: 24)
            : const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ), // No constraints if no icon
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Matched to design
          borderSide: BorderSide(
            color: AppColors.lightGrey.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColors.lightGrey.withOpacity(0.5),
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
        filled: true, // Added for background color
        fillColor: AppColors.white, // Background color for text field
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0, // Adjusted padding
          horizontal: 16.0,
        ),
        floatingLabelBehavior: widget.labelText != null
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
      ),
    );
  }
}
