import 'package:flutter/material.dart';

class PageTile extends StatelessWidget {
  PageTile(
      {required this.label,
      required this.iconData,
      required this.onTap,
      required this.highlighted});

  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: highlighted
                ? Theme.of(context).colorScheme.surfaceTint
                : Theme.of(context).hintColor),
      ),
      leading: Icon(
        iconData,
        color: highlighted
            ? Theme.of(context).colorScheme.surfaceTint
            : Theme.of(context).hintColor,
      ),
      onTap: onTap,
    );
  }
}
