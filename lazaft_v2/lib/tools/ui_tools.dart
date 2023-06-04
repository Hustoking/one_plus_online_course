import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UiTools {
  static Future<bool> onBackPressed(BuildContext context) {
    return UiTools.showCustomDialog(context, "提示", "确定要退出吗？", "取消",
        onPressed: () {
      SystemNavigator.pop();
    });
  }

  static showCustomDialog(
      BuildContext context, String title, String content, String cancelText,
      {String? confirmText, VoidCallback? onPressed}) {
    // 不传入 onPressed 时，默认 pop 操作
    onPressed ??= () {
      // 默认操作
      Navigator.of(context).pop("ok");
    };
    // TODO: ~~点击 Dialog 确定按钮无法跳转路由的功能还没解决~~ 已解决
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop("cancel"),
              child: Text(cancelText ?? "取消"),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(confirmText ?? "确定"),
            ),
          ],
        );
      },
    );
  }
}
