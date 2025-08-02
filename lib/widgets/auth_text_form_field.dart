import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    super.key,
    required this.hint,
    required this.isPasswordField,
    required this.prefixIcon,
    required this.controller,
    required this.title,
  });
  final String title;
  final String hint;
  final bool isPasswordField;
  final Widget? prefixIcon;
  final TextEditingController controller;

  @override
  AuthTextFormFieldState createState() => AuthTextFormFieldState();
}

class AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.title,
            style: const TextStyle(color: greyColor),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: primaryColor,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          scrollPadding: EdgeInsets.zero,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Color(0xFFB0AEB1), fontSize: 12),
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                widget.isPasswordField
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: greyColor, // زي ما طلبتي
                      ),
                      onPressed: _togglePasswordVisibility,
                    )
                    : null,
            filled: true,
            fillColor: whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
      ],
    );
  }
}
