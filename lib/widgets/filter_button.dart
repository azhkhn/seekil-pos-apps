import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.onTap,
    this.icon = Icons.keyboard_arrow_down_rounded,
    required this.text,
    this.isSelected = false,
  });
  final void Function()? onTap;
  final IconData? icon;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: isSelected ? null : Border.all(color: Colors.grey),
            color: isSelected ? ColorConstant.DEF : null),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(width: 4.0),
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
