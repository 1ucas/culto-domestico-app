import 'package:flutter/material.dart';

class AppDropdownField<T> extends DropdownButtonFormField<T> {
  AppDropdownField({FormFieldValidator<T> validator, @required String titulo, @required this.items, @required this.onChanged, T value})
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
  final ValueChanged<T> onChanged;
}
