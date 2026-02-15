import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meu_doce_custo/core/global/back4app.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../features/user/stores/user_manager_store.dart';
import '../features/auth/screens/logged_verify.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigureDependencies();

  try {
    await Back4App.initParse();
  } catch (e) {
    log('Erro ao inicializar o Parse: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userManagerStore = GetIt.I<UserManagerStore>();

  @override
  void initState() {
    super.initState();
    userManagerStore.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(350, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(600, name: TABLET),
          const ResponsiveBreakpoint.resize(800, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(1700, name: "XL"),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Meu Doce Custo',
      home: const LoggedVerify(),
    );
  }
}
