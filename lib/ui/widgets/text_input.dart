import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final bool enabled;
  final TextInputType keyboardType;
  final Function(String) onChanged;

  TextInput(
      {this.controller,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.label = "",
      this.maxLines = 1,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        width: double.infinity,
        child: TextField(
          enabled: enabled,
          controller: controller,
          maxLines: maxLines,
          minLines: 1,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              labelText: label,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0)),
        ));
  }
}
