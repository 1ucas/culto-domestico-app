import 'package:culto_domestico_app/app/common/styles/app_styles.dart';
import 'package:flutter/material.dart';

class AppNumericFormField extends TextFormField {

  // Somente para testes
  final String titulo;

  AppNumericFormField({
    @required this.titulo,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    Key key,
  }) : super(
          key: key,
          validator: validator,
          controller: controller,
          buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
          keyboardType: TextInputType.number,
          maxLength: 3,
          decoration: InputDecoration(
            labelText: titulo,
            labelStyle: TextStyle(color: AppStyle.PrimaryColor),
            hintStyle: TextStyle(color: AppStyle.PrimaryColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppStyle.SecondaryColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppStyle.PrimaryColor)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.black38),
            ),
          ),
        );
}
