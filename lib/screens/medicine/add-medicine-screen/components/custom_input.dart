import 'package:Capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.labelText,
    this.initialValue,
    this.suffixText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.border = const UnderlineInputBorder(),
    this.inputFormatters = const [],
  });

  final String? labelText;
  final String? suffixText;
  final String? initialValue;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final InputBorder border;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        border: border,
        suffixText: suffixText,
        labelText: labelText,
        errorStyle: const TextStyle(color: MyColors.lightRed),
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
