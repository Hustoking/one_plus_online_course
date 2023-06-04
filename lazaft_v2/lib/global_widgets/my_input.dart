import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyInput extends StatelessWidget {
  const MyInput.email(
      {Key? key,
      this.hintText = "example@abc.com",
      this.formatterStr = "email",
      this.validatorStr = "email",
      this.enable = true,
      this.onSave,
      this.onChange,
      this.validator})
      : super(key: key);

  const MyInput.pswd(
      {Key? key,
      this.hintText = "Please input your password",
      this.formatterStr = "pswd",
      this.validatorStr = "pswd",
      this.enable = true,
      this.onSave,
      this.onChange,
      this.validator})
      : super(key: key);

  const MyInput.checkPswd(
      {Key? key,
      this.hintText = "Check your password",
      this.formatterStr = "pswd",
      this.validatorStr = "",
      this.enable = true,
      this.onSave,
      this.onChange,
      required this.validator})
      : super(key: key);

  const MyInput.nickName({
    Key? key,
    this.hintText = "Your nick name",
    this.formatterStr = "nickName",
    this.validatorStr = "nickName",
    this.enable = true,
    this.onSave,
    this.onChange,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final String formatterStr;
  final String validatorStr;
  final validator;
  final onSave;
  final onChange;
  final bool enable;

  static final emailFormatter = FilteringTextInputFormatter.allow(
      // Email：允许 数字、字母、特殊字符
      RegExp('[0-9a-zA-Z@._!@#\$%^&*]'));
  static final accountFormatter = FilteringTextInputFormatter.allow(
      // 账号：只允许 数字、字母
      RegExp('[0-9a-zA-Z]'));
  static final pswdFormatter = FilteringTextInputFormatter.allow(
      // 密码：只允许 数字、字母、特殊字符
      RegExp('[0-9a-zA-Z_!@#\$%^&*(),.?":{}|<>]'));
  static final numberFormatter = FilteringTextInputFormatter.allow(
      // 数字：只允许 数字
      RegExp('[0-9]'));
  static final nickNameFormatter = FilteringTextInputFormatter.allow(
      // 昵称：只允许 数字、字母、中文
      RegExp('[0-9a-zA-Z\u4e00-\u9fa5]'));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 12,
            // 为了给 TextFormField 的 helper 让路，故只能向上偏移12
            offset: Offset(0, -12),
          ),
        ],
      ),
      // ================================================= Text Form Field =================================================
      child: TextFormField(
        // 不给默认值会报错
        enabled: enable,
        onChanged: onChange != null ? (value) => onChange(value) : (value) {},
        onSaved: onSave != null
            ? (value) => onSave(value)
            // TODO: onSave 不传值 行为
            : (value) => debugPrint("=== On Save Default ===" + value!),
        validator: (value) {
          if (validatorStr == "email") {
            return LoginValidators.emailValidator(value);
          } else if (validatorStr == "pswd") {
            return LoginValidators.pswdValidator(value);
          } else if (validatorStr == "nickName") {
            return LoginValidators.nickNameValidator(value);
          }
          return validator == null ? null : validator(value);
        },
        obscureText: formatterStr == "pswd" ? true : false,
        inputFormatters: [
          if (formatterStr == "email") emailFormatter,
          if (formatterStr == "account") accountFormatter,
          if (formatterStr == "pswd") pswdFormatter,
          if (formatterStr == "number") numberFormatter,
          if (formatterStr == "nickName") nickNameFormatter,
        ],
        decoration: InputDecoration(
          helperText: '',
          filled: true,
          fillColor: Colors.white,
          hintText: '$hintText',
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class LoginValidators {
  // 用户名及密码表单效验
  static String? userAccountValidator(value) {
    if (value == null || value.isEmpty == true) {
      return '用户名不能为空';
    } else if (value.length <= 4) {
      return '用户名长度不能小于5位';
    }
    return null;
  }

  static String? pswdValidator(value) {
    if (value == null || value.isEmpty == true) {
      return '密码不能为空';
    } else if (value.length <= 4) {
      return '密码长度不能小于5位';
    }
    return null;
  }

  static String? emailValidator(value) {
    if (value == null || value.isEmpty == true) {
      return '邮箱不能为空';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '请输入正确的邮箱地址';
    }
    return null;
  }

  static String? nickNameValidator(value) {
    if (value == null || value.isEmpty == true) {
      return '昵称不能为空';
    } else if (value.length < 2) {
      return '昵称太短';
    }
    return null;
  }
}
