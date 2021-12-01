import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';

class MultiDropdown extends StatelessWidget {
  const MultiDropdown(
      {Key? key,
      required this.items,
      this.dropdownItemKeyValue,
      required this.onConfirm,
      this.title = 'Select',
      this.validator})
      : super(key: key);

  final List<dynamic>? items;
  final DropdownItemKeyValue? dropdownItemKeyValue;
  final Function onConfirm;
  final String title;
  final String? Function(List<dynamic>?)? validator;

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      items: items!
          .map((e) => MultiSelectItem(e[dropdownItemKeyValue?.value ?? 'id'],
              e[dropdownItemKeyValue?.text ?? 'name']))
          .toList(),
      onConfirm: (values) => onConfirm(values),
      validator: validator,
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      title: Text(title),
      buttonText: Text(title),
    );
  }
}
