import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchableTextFormField extends StatelessWidget {
  const SearchableTextFormField(
      {Key? key,
      this.validator,
      required this.onSuggestionSelected,
      required this.itemBuilder,
      required this.suggestionsCallback})
      : super(key: key);
  final String? Function(String?)? validator;
  final void Function(dynamic) onSuggestionSelected;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: itemBuilder,
        validator: validator,
        suggestionsCallback: suggestionsCallback);
  }
}
