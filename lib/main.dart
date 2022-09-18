import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:smart_hospital/src/bloc/BlocObserver.dart';
import 'package:smart_hospital/src/bloc/auth/auth_bloc.dart';
import 'package:smart_hospital/src/bloc/auth_pin/auth_pin_bloc.dart';
import 'package:smart_hospital/src/bloc/create_pin/create_pin_bloc.dart';
import 'package:smart_hospital/src/pages/home/home_page.dart';
import 'package:smart_hospital/src/pages/login/login_page.dart';
import 'package:smart_hospital/src/pages/my_app.dart';
import 'package:smart_hospital/src/utils/app_theme.dart';
import 'package:smart_hospital/src/utils/constants.dart';

void main() async {
  await Hive.initFlutter();
  BlocOverrides.runZoned(
    () {
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc()..add(AuthEventAppStart()),
            ),
            BlocProvider<AuthPinBloc>(
              create: (_) => AuthPinBloc(authenticationBloc: BlocProvider.of<AuthBloc>(_)),
            ),
            BlocProvider<CreatePINBloc>(
              create: (_) => CreatePINBloc(authenticationBloc: BlocProvider.of<AuthBloc>(_)),
            ),
          ],
          child: MyApp(),
        ),
      );
    },
    blocObserver: SimpleBlocObserver(),
  );
}
