import 'package:flutter/material.dart';

class FavButton extends StatelessWidget {
  final Color color;
  final Color pressedColor;
  final bool checked;
  final Function onPressed;

  const FavButton({
    @required this.checked,
    @required this.color,
    @required this.pressedColor,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.bottomRight,
      color: checked ? pressedColor : color,
      icon: checked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onPressed: () {
        onPressed(!checked);
      },
    );
  }
}
