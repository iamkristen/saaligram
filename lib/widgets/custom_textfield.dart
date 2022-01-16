import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData prefixIcon;
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isPass;

  const CustomTextField(
      {Key? key,
      required this.prefixIcon,
      required this.controller,
      required this.hintText,
      required this.label,
      required this.isPass})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 30,
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(0.15),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(35.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldPassword extends StatefulWidget {
  final IconData prefixIcon;
  final TextEditingController controller;
  final String hintText;
  final String label;

  const CustomTextFieldPassword({
    Key? key,
    required this.prefixIcon,
    required this.controller,
    required this.hintText,
    required this.label,
  }) : super(key: key);

  @override
  State<CustomTextFieldPassword> createState() =>
      _CustomTextFieldPasswordState();
}

class _CustomTextFieldPasswordState extends State<CustomTextFieldPassword> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          labelText: widget.label,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 30,
          ),
          suffixIcon: IconButton(
            icon: _obscureText
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          filled: true,
          fillColor: Theme.of(context).primaryColor.withOpacity(0.15),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(35.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
      ),
    );
  }
}
