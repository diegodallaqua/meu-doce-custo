import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../global/theme/custom_colors.dart';

class CustomFormField extends StatefulWidget {
  final bool secret;
  final List<TextInputFormatter>? input;
  final String? error;
  final String? initialvalue;
  final onChanged;
  final String? suffixText;
  final Function? set_visible;
  final bool visible;
  final Key? keyy;
  final TextInputType? typeKeyboard;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final TextAlign? textAlign;

  CustomFormField({
    Key? key,
    this.secret = false,
    this.input,
    required this.error,
    this.initialvalue,
    this.onChanged,
    this.suffixText,
    this.set_visible = null,
    this.visible = false,
    this.keyy,
    this.typeKeyboard,
    this.textInputAction,
    this.onFieldSubmitted,
    this.controller,
    this.textAlign,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final border = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: CustomColors.mint,
      width: 1,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        textAlign: widget.textAlign ?? TextAlign.start,
        controller: widget.controller,
        cursorColor: CustomColors.just_regular_brown,
        keyboardType: widget.typeKeyboard,
        key: widget.keyy,
        style: const TextStyle(color: CustomColors.just_regular_brown),
        initialValue: widget.initialvalue,
        onChanged: widget.onChanged,
        inputFormatters: widget.input,
        obscureText: widget.secret ? widget.visible : false,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          suffixText: widget.suffixText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.mint.withOpacity(0.6), width: 1),
          ),
          errorText: widget.error,
          suffixIcon: widget.secret ? IconButton(
            onPressed: () {
              widget.set_visible!();
            },
            icon: Icon(
              widget.visible ? Icons.visibility_off : Icons.visibility,
            ),
          ) : null,
        ),
      ),
    );
  }
}
