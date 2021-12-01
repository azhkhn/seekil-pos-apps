import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/forms/form_field.dart';

// ignore: must_be_immutable
class Dropdown extends StatelessWidget {
  Dropdown({
    Key? key,
    required this.items,
    required this.currentValue,
    required this.onSaved,
    this.dropdownItemKeyValue,
    this.selectedItem,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  final List? items;
  final dynamic currentValue;
  final ValueChanged<dynamic>? onSaved;
  final ValueChanged<dynamic>? onChanged;
  final DropdownItemKeyValue? dropdownItemKeyValue;
  final ValueChanged<dynamic>? selectedItem;
  final String? Function(dynamic)? validator;

  dynamic initCurrentValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: currentValue != null ? currentValue : initCurrentValue,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      isExpanded: true,
      iconSize: 24,
      validator: validator,
      elevation: 16,
      onSaved: (dynamic newValue) => onSaved!(newValue),
      onChanged: (dynamic newValue) {
        initCurrentValue = newValue;
        onChanged!(initCurrentValue);
      },
      items: items?.map<DropdownMenuItem>((dynamic item) {
        return DropdownMenuItem(
          value: item[dropdownItemKeyValue?.value ?? 'id'],
          child: Text(item[dropdownItemKeyValue?.text ?? 'name']),
        );
      }).toList(),
    );
  }
}
