import 'package:flutter/material.dart';
import 'package:muhjaaa/utils/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget prefixIcon;
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
    required this.labelText,
    required this.prefixIcon,
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
    // Listen to focus changes
    _focusNode.addListener(_onFocusChange);
    // Listen to text changes to validate live if focused
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    // Note: Don't dispose the controller here if it's passed from parent
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // When field loses focus, clear its specific live error message.
      // Form-level validation on submit will still catch it if it's an error.
      if (mounted && _currentErrorText != null) {
        setState(() {
          _currentErrorText = null;
        });
      }
      // We can also choose to validate one last time on blur:
      // if (widget.validator != null) {
      //   final error = widget.validator!(widget.controller.text);
      //   if (mounted && _currentErrorText != error) { // Update only if error state changes
      //     setState(() {
      //       _currentErrorText = error; // This would make errors persist on blur
      //     });
      //   }
      // }
    } else {
      // When field gains focus, validate immediately
      _validate();
    }
  }

  void _onTextChanged() {
    // Only validate and show errors if the field currently has focus
    if (_focusNode.hasFocus) {
      _validate();
    }
  }

  void _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      if (mounted && _currentErrorText != error) {
        // Update only if error state changes
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
      validator: widget.validator, // Validator for form submission
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      autovalidateMode:
          AutovalidateMode.disabled, // We handle live error via errorText
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16.0,
        color: AppColors.darkGreyText,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16.0,
          color: AppColors.lightGrey,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: _focusNode.hasFocus
              ? AppColors.primaryRed
              : AppColors.lightGrey,
          fontSize: 18.0,
        ),
        errorText: _currentErrorText, // Display our managed error text
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: widget.prefixIcon,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          // Border when errorText is not null and field is not focused
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Border when errorText is not null and field is focused
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ),
        filled: true,
        fillColor: AppColors.white,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
