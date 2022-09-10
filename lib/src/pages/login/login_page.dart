import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import 'components/form_register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: LoginForm(),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColor.bgColor,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              "${Constants.createBy}",
              style: TextStyle(color: AppColor.textSecondaryColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
