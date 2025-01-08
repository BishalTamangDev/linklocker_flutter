import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.context,
    required this.autofocus,
    required this.controller,
    required this.hintText,
    required this.leadingIcon,
    required this.leadingIconColor,
    this.maxLine = 1,
  });

  final BuildContext context;
  final bool autofocus;
  final TextEditingController controller;
  final String hintText;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLine,
      decoration: InputDecoration(
        prefixIcon: Icon(
          leadingIcon,
          color: leadingIconColor,
        ),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
