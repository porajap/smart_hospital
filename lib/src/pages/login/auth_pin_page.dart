import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_hospital/src/bloc/auth_pin/auth_pin_bloc.dart';
import 'package:smart_hospital/src/pages/home/home_page.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/my_dialog.dart';

import '../../bloc/create_pin/create_pin_bloc.dart';
import '../../data/pin_repository.dart';
import 'components/button_of_numpad.dart';
import 'components/pin_sphere.dart';

class AuthPIN extends StatefulWidget {
  const AuthPIN({Key? key}) : super(key: key);

  @override
  State<AuthPIN> createState() => _AuthPINState();
}

class _AuthPINState extends State<AuthPIN> {
  static const String setupPIN = "Setup PIN";
  static const String useSixDigitsPIN = "Use 6-digits PIN";
  static const String authenticationSuccess = "Authentication success";
  static const String authenticationFailed = "Authentication failed";
  static const String ok = "OK";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        lazy: false,
        create: (_) => AuthenticationPinBloc(pinRepository: HivePINRepository()),
        child: BlocListener<AuthenticationPinBloc, AuthenticationPinState>(
          listener: (context, state) {
            if (state.pinStatus == AuthenticationPINStatus.equals) {
              MyDialog.dialogCustom(
                context: context,
                callback: () {
                  goHomePage();
                },
                title: authenticationSuccess,
                msg: '',
                cancelText: ok,
              );
            } else if (state.pinStatus == AuthenticationPINStatus.unequals) {
              MyDialog.dialogCustom(
                title: authenticationFailed,
                context: context,
                cancelText: ok,
                callback: () {
                  context.read<CreatePINBloc>().add(CreateNullPINEvent());
                },
                msg: '',
              );
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(flex: 2, child: _MainPart()),
                    Expanded(flex: 3, child: _NumPad()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goHomePage() async {
    Navigator.pushAndRemoveUntil(context, HomePage.route(), (_) => false);
  }

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AuthPIN());
  }
}

class _NumPad extends StatelessWidget {
  const _NumPad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(64, 0, 64, 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: ButtonOfNumPad(
                    num: '1',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 1));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '2',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 2));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '3',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 3));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: ButtonOfNumPad(
                    num: '4',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 4));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '5',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 5));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '6',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 6));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: ButtonOfNumPad(
                    num: '7',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 7));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '8',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 8));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '9',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 9));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: ButtonOfNumPad(
                    num: '0',
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinAddEvent(pinNum: 10));
                    },
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      context.read<AuthenticationPinBloc>().add(AuthenticationPinEraseEvent());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainPart extends StatelessWidget {
  static const String enterYourPIN = "Enter your PIN";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationPinBloc, AuthenticationPinState>(
      buildWhen: (previous, current) {
        return previous.pin != current.pin;
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              flex: 2,
              child: Text(
                enterYourPIN,
                style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 36),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => PinSphere(input: index < state.getCountsOfPIN())),
              ),
            ),
          ]),
        );
      },
    );
  }
}
