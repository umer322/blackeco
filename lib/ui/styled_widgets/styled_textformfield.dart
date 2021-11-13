import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class StyledTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Color? backGroundColor;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onChanged;
  final TextInputType? inputType;
  final bool? obscureText;
  final Widget? leadingIcon;
  final bool? enabled;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final FormFieldSetter<String>? onSaved;
  final int? maxLines;
  StyledTextFormField({this.enabled,this.maxLines,this.suffixIcon,this.obscureText,this.leadingIcon,this.onChanged,this.controller,this.labelText,this.hintText,this.backGroundColor,this.validator,this.onSaved,this.inputType,this.initialValue,this.inputFormatter});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        onSaved: onSaved,
        validator: validator,
        initialValue: initialValue,
        maxLines: maxLines??1,
        enabled: enabled??true,
        obscureText: obscureText??false,
        inputFormatters: inputFormatter,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
            prefixIcon: leadingIcon,
            filled: backGroundColor!=null?true:false,
            fillColor: backGroundColor,
            hintText: hintText,
            labelText: labelText,
            suffixIcon: suffixIcon,
          enabledBorder: kIsWeb?OutlineInputBorder(borderRadius: BorderRadius.circular(10)):null,
          focusedBorder: kIsWeb?OutlineInputBorder(borderRadius: BorderRadius.circular(10)):null
        ),
      ))
    ],);
  }
}
