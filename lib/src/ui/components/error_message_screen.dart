import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key? key,
    required this.message,
    this.onTap,
    this.color,
    this.iconSize = 64.0,
    this.icon = Icons.warning,
    this.space = 10.0,
    this.padding = const EdgeInsets.all(20.0),
  }) : super(key: key);

  final String message;
  final Color? color;
  final double iconSize;
  final IconData icon;
  final double space;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildIcon(),
            SizedBox(height: space),
            _buidlText(),
            SizedBox(height: space),
            if (onTap != null) _buildButton(),
          ],
        ),
      ),
    );
  }

  _buildIcon() {
    return Icon(
      icon,
      color: color,
      size: iconSize,
    );
  }

  _buidlText() {
    return SingleChildScrollView(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: color),
      ),
    );
  }

  _buildButton() {
    return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.refresh,
          size: 30,
          color: Colors.blue,
        ));
  }
}
