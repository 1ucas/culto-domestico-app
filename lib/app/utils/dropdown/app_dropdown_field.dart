import 'package:flutter/material.dart';

class AppDropdownField<T> extends DropdownButtonFormField<T> {
  AppDropdownField({required FormFieldValidator<T> validator, required String titulo, required this.items, required ValueChanged<T?> onChanged, T? value})
      : super(
          value: value,
          decoration: InputDecoration(
            labelText: titulo,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          elevation: 16,
          onChanged: onChanged,
          items: items,
          validator: validator,
        );

  final List<DropdownMenuItem<T>> items;
}
