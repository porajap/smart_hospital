import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_hospital/src/pages/home/home_page.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/my_dialog.dart';

import '../../bloc/create_pin/create_pin_bloc.dart';
import '../../data/pin_repository.dart';

class CreatePIN extends StatefulWidget {
  const CreatePIN({Key? key}) : super(key: key);

  @override
  State<CreatePIN> createState() => _CreatePINState();
}

class _CreatePINState extends State<CreatePIN> {
  static const String setupPIN = "Setup PIN";
  static const String useSixDigitsPIN = "Use 6-digits PIN";
  static const String pinCreated = "Your PIN code is successfully";
  static const String pinNonCreated = "Pin codes do not match";
  static const String ok = "OK";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        lazy: false,
        create: (_) => CreatePINBloc(pinRepository: HivePINRepository()),
        child: BlocListener<CreatePINBloc, CreatePINState>(
          listener: (context, state) {
            if (state.pinStatus == PINStatus.equals) {
              MyDialog.dialogCustom(
                context: context,
                callback: () {
                  goHomePage();
                },
                title: pinCreated,
                msg: '',
                cancelText: ok,
              );
            } else if (state.pinStatus == PINStatus.unequals) {
              MyDialog.dialogCustom(
                title: pinNonCreated,
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

  Future<void> goHomePage() async{
    Navigator.pushAndRemoveUntil(context, HomePage.route(), (_) => false);
  }

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreatePIN());
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
                    num: 1,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 1));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 2,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 2));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 3,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 3));
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
                    num: 4,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 4));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 5,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 5));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 6,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 6));
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
                    num: 7,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 7));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 8,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 8));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 9,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 9));
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
                SizedBox(width: 64),
                Expanded(
                  child: ButtonOfNumPad(
                    num: 0,
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINAddEvent(pinNum: 10));
                    },
                  ),
                ),
                SizedBox(width: 64),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      context.read<CreatePINBloc>().add(CreatePINEraseEvent());
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

  Widget ButtonOfNumPad({required int num, required VoidCallback onPressed}) => FittedBox(
        child: FloatingActionButton.extended(
          elevation: 0,
          heroTag: num,
          backgroundColor: AppColor.grayColor,
          onPressed: onPressed,
          label: Text(
            "$num",
            style: TextStyle(color: AppColor.textPrimaryColor),
          ),
        ),
      );
}

class _MainPart extends StatelessWidget {
  static const String createPIN = "Create PIN";
  static const String reEnterYourPIN = "Re-enter your PIN";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePINBloc, CreatePINState>(
      buildWhen: (previous, current) {
        return previous.firstPIN != current.firstPIN || previous.secondPIN != current.secondPIN;
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              flex: 2,
              child: Text(
                state.pinStatus == PINStatus.enterFirst ? createPIN : reEnterYourPIN,
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

class PinSphere extends StatelessWidget {
  final bool input;

  const PinSphere({Key? key, required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: input ? AppColor.primaryColor : null,
          border: Border.all(color: AppColor.primaryColor.withOpacity(0.75), width: 1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
