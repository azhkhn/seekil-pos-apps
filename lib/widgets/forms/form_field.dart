import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/forms/dropdown.dart';
import 'package:seekil_back_office/widgets/forms/multi_dropdown.dart';

class DropdownItemKeyValue {
  final dynamic value;
  final dynamic text;

  DropdownItemKeyValue({this.value, this.text});
}

enum FormFieldType { DROPDOWN, MULTI_DROPDOWN, TEXT, SEARCHABLE_TEXT_FIELD }

class MyFormField extends StatelessWidget {
  final String label;
  final bool readOnly;
  final FormFieldType type;
  final String? initialValue;
  final TextInputType? textInputType;
  final VoidCallback? onTap;
  final ValueChanged<dynamic>? onSaved;
  final ValueChanged<dynamic>? onChanged;
  final String? Function(String?)? textFieldValidator;
  final String? Function(dynamic)? dropdowndValidator;
  final String? Function(List<dynamic>?)? multiDropdownValidator;
  final TextEditingController? controller;
  final List? dropdownItems;
  final dynamic dropdownCurrentValue;
  final DropdownItemKeyValue? dropdownItemKeyValue;
  final ValueChanged<dynamic>? dropdownSelectedItem;
  final InputDecoration? inputDecoration;
  final TextCapitalization textCapitalization;
  final bool isMandatory;
  final bool obscureText;

  MyFormField(
      {Key? key,
      this.obscureText = false,
      this.isMandatory = false,
      this.readOnly = false,
      this.type = FormFieldType.TEXT,
      this.textInputType = TextInputType.text,
      this.textCapitalization = TextCapitalization.sentences,
      this.dropdownItems,
      required this.label,
      this.initialValue,
      this.onTap,
      this.dropdownCurrentValue,
      this.onSaved,
      this.controller,
      this.dropdownItemKeyValue,
      this.onChanged,
      this.dropdownSelectedItem,
      this.inputDecoration,
      this.textFieldValidator,
      this.dropdowndValidator,
      this.multiDropdownValidator})
      : super(key: key);

  final InputDecoration _inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
  );

  @override
  Widget build(BuildContext context) {
    Widget _checkType() {
      switch (type) {
        case FormFieldType.MULTI_DROPDOWN:
          return MultiDropdown(
            items: dropdownItems,
            onConfirm: (dynamic values) => dropdownSelectedItem!(values),
            dropdownItemKeyValue: dropdownItemKeyValue,
            validator: multiDropdownValidator,
          );
        case FormFieldType.DROPDOWN:
          return Dropdown(
            items: dropdownItems,
            currentValue: dropdownCurrentValue,
            onSaved: (dynamic value) => onSaved!(value),
            onChanged: (dynamic value) => onChanged!(value),
            dropdownItemKeyValue: dropdownItemKeyValue,
            selectedItem: (dynamic item) => dropdownSelectedItem!(item),
            validator: dropdowndValidator,
          );
        default:
          return TextFormField(
              readOnly: readOnly,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: initialValue,
              validator: textFieldValidator,
              keyboardType: textInputType,
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              onTap: () => onTap,
              controller: controller,
              onSaved: (dynamic newValue) => onSaved!(newValue!),
              onChanged: onChanged != null
                  ? (dynamic value) => onChanged!(value)
                  : null,
              decoration:
                  inputDecoration != null ? inputDecoration : _inputDecoration);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 4.0,
              ),
              if (isMandatory)
                Text(
                  '*',
                  style: TextStyle(color: Colors.grey),
                )
            ],
          ),
          SizedBox(height: 8),
          _checkType()
        ],
      ),
    );
  }
}
