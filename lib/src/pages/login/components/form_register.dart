import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_hospital/main.dart';
import 'package:smart_hospital/src/model/login/check_phone_model.dart';
import 'package:smart_hospital/src/model/login/first_model.dart';
import 'package:smart_hospital/src/pages/login/create_pin_page.dart';
import 'package:smart_hospital/src/utils/my_dialog.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/constants.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error;

import '../../../utils/my_widget.dart';
import '../../my_app.dart';
import '../auth_pin_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController(text: "0123456789");
  bool isEnabledButton = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              child: Image.asset("${Constants.imageUrl}/logo.png", width: 180,),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Text("กรอกเบอร์โทรศัพท์ของคุณ", style: TextStyle(color: AppColor.textPrimaryColor, fontWeight: FontWeight.bold),),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffixIcon: SizedBox(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length == 0) {
                      return 'กรุณากรอกเบอร์มือถือ 10 หลัก';
                    }

                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Widget buildButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: !isEnabledButton ? null : login,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("${Constants.loginSignIn}"),
          ),
        ),
      );

  Future<void> login() async {
    context.read<AuthBloc>().add(AuthEventCheckLogin(phone: _phoneController.text.trim()));
  }

}
