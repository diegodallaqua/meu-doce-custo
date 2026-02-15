// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import '../../../app/shell/base_screen.dart';
import '../../../core/global/theme/custom_colors.dart';
import '../../user/stores/user_manager_store.dart';
import '../repositories/token_repository.dart';
import 'login_screen.dart';

class LoggedVerify extends StatefulWidget {
  const LoggedVerify({Key? key}) : super(key: key);

  @override
  State<LoggedVerify> createState() => _LoggedVerifyState();
}

class _LoggedVerifyState extends State<LoggedVerify> {
  final userManagerStore = GetIt.I<UserManagerStore>();

  @override
  void initState() {
    super.initState();

    TokenRepository().verifyToken().then((value) async {
      if (value) {
        bool aux = await userManagerStore.LoggedTrue();

        if (aux) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BaseScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        TokenRepository().exit();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return userManagerStore.loading ? const Center(
          child: CircularProgressIndicator(
            color: CustomColors.gay_pink,
          ),
        ) : Container();
      },
    );
  }
}
