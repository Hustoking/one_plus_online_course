import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  // 大号按钮
  const MyButton.large(
      {Key? key,
      this.isLoading = false,
      this.onPress,
      this.title,
      this.backgroundColor = const Color(0xFF5667FD),
      this.height = 46,
      this.width = 200,
      this.fontColor = const Color(0xFFFFFFFF)})
      : super(key: key);

  // 中号按钮
  const MyButton.middle(
      {Key? key,
      this.isLoading = false,
      this.onPress,
      this.title,
      this.backgroundColor = const Color(0xff3D405B),
      this.width = 135,
      this.height = 39,
      this.fontColor = const Color(0xffF4F1DE)})
      : super(key: key);

  // 小号按钮
  const MyButton.small(
      {Key? key,
      this.isLoading = false,
      this.onPress,
      this.title,
      this.backgroundColor = const Color(0xff3D405B),
      this.width = 90,
      this.height = 39,
      this.fontColor = const Color(0xffF4F1DE)})
      : super(key: key);

  final onPress;
  final title;
  final Color backgroundColor;
  final Color fontColor;

  final double height;
  final double width;

  final bool isLoading;

  // final double height = 46;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: isLoading
            ? MaterialStateProperty.all<Color>(backgroundColor.withOpacity(0.9))
            : MaterialStateProperty.all<Color>(backgroundColor),
        // 大小
        fixedSize: MaterialStateProperty.all<Size>(Size(width, height)),
        // 阴影
        elevation: MaterialStateProperty.all<double>(2),
        // 圆角
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: isLoading ? null : onPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        fontColor.withOpacity(0.4)),
                  ))
              : const SizedBox(),
          isLoading ? const SizedBox(width: 10) : const SizedBox(),
          Text(title,
              style: TextStyle(
                  color: isLoading ? fontColor.withOpacity(0.4) : fontColor,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class HollowButton extends StatelessWidget {
  const HollowButton.middle(
      {Key? key,
      this.isLoading = false,
      this.onPress,
      this.title,
      this.fontColor = const Color(0xffff3D405B),
      this.height = 39,
      this.width = 135,
      this.backgroundColor = const Color(0xffF4F5F9)})
      : super(key: key);

  final onPress;
  final title;
  final fontColor;
  final backgroundColor;

  final double height;
  final double width;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: fontColor, width: 2),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isLoading
                ? SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          fontColor.withOpacity(0.4)),
                    ))
                : const SizedBox(),
            isLoading ? const SizedBox(width: 10) : const SizedBox(),
            Text(title,
                style:
                    TextStyle(color: fontColor, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
