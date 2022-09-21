import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:smart_hospital/src/bloc/auth_pin/auth_pin_bloc.dart';
import 'package:smart_hospital/src/pages/dashboard/dashboard.dart';

import '../bloc/auth/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../utils/my_dialog.dart';
import 'home/home_page.dart';
import 'login/auth_pin_page.dart';
import 'login/create_pin_page.dart';
import 'login/login_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final logger = Logger(
  printer: PrettyPrinter(),
);

final loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      Logger.level = Level.nothing;
    } else {
      Logger.level = Level.debug;
    }

    return MaterialApp(
      title: '${Constants.appName}',
      theme: AppTheme.primaryTheme,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      home: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          BotToast.closeAllLoading();

          if (state is AuthStateLoading) {
            BotToast.showLoading();
          }

          if (state is AuthStateCheckLogin) {
            var _checkLoginData = state.checkLoginData;
            bool _firstLogin = _checkLoginData.data?.firstLogin ?? false;
            bool _error = _checkLoginData.error ?? false;
            context.read<AuthPinBloc>().add(AuthNullPINEvent());

            if (_error) {
              WidgetsBinding.instance.addPostFrameCallback((_) => MyDialog.dialogCustom(
                context: context,
                title: "Message",
                msg: "ไม่พบข้อมูลของคุณ กรุณาติดต่อเจ้าหน้าที่",
              ));

            }
          }

          if (state is AuthStatePINUnEqual) {
            BotToast.showText(text: "PIN ไม่ถูกต้อง");
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            BotToast.closeAllLoading();

            if (state is AuthStateTokenInvalid) {
              BotToast.showText(text: "Token invalid");

              WidgetsBinding.instance
                  .addPostFrameCallback((_) => Navigator.popUntil(context, (route) => route.isFirst));

              return LoginPage();
            }

            if (state is AuthStateCheckLogin) {
              var _checkLoginData = state.checkLoginData;
              bool _firstLogin = _checkLoginData.data?.firstLogin ?? false;
              bool _error = _checkLoginData.error ?? false;
              context.read<AuthPinBloc>().add(AuthNullPINEvent());

              if (_error) {
                return LoginPage();
              } else if (_firstLogin) {
                return CreatePIN();
              } else {
                return AuthPIN();
              }
            }

            if (state is AuthStateUnauthenticated) {
              return LoginPage();
            }

            if (state is AuthStatePINUnEqual) {
              context.read<AuthPinBloc>().add(AuthNullPINEvent());
              return AuthPIN();
            }

            if (state is AuthStateAuthenticated) {
              if (state.role == 1) {
                return Dashboard();
              }
              return HomePage();
            }

            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
