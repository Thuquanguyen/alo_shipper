import 'package:flutter/material.dart';
import 'package:shipper/widget/touchable.dart';

class CircleAvatarLetter extends StatelessWidget {
  const CircleAvatarLetter(
      {Key? key,
      required this.name,
      required this.size,
      this.borderWidth = 0,
      this.borderColor = Colors.grey,
      this.backgroundColor = Colors.white,
      this.color = Colors.green,
      this.onTap})
      : super(key: key);

  final String name;
  final double size;
  final double borderWidth;
  final Color borderColor;
  final Color color;
  final Function? onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    double w = size;
    double r = size / 2;

    return Touchable(
      onTap: onTap != null
          ? () {
              onTap?.call();
            }
          : null,
      child: borderWidth > 0
          ? Container(
              width: w,
              height: w,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(r))),
              child: buildCircleAvatar(context, r, backgroundColor, color),
            )
          : buildCircleAvatar(context, r, backgroundColor, color),
    );
  }

  CircleAvatar buildCircleAvatar(BuildContext context, double r, Color backgroundColor, Color color) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: r,
      child: Text(
        getLetterAvatar(name),
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'sans-serif', color: color, fontWeight: FontWeight.w500, fontSize: r * 0.8),
      ),
    );
  }

  String getLetterAvatar(String name) {
    final tmp = name.split(' ');
    if (tmp.length >= 2) {
      String tmp1 = tmp[0];
      String tmp2 = tmp[tmp.length - 1];
      return '${tmp1[0]}${tmp2[0]}'.toUpperCase();
    } else if (name.length > 1) {
      return '${name[0]}${name[1]}'.toUpperCase();
    } else {
      return name.toUpperCase();
    }
  }

}
