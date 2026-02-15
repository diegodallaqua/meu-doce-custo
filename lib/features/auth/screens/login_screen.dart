// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import '../../../core/global/theme/custom_colors.dart';
import '../../../core/global/utils.dart';
import '../../../app/shell/base_screen.dart';
import '../../user/screens/register_screen.dart';
import '../stores/login_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final FToast fToast;
  late ReactionDisposer disposer;
  final loginStore = GetIt.I<LoginStore>();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    disposer = reaction((_) => loginStore.error, (error) {
      if (error != null) {
        Utils.showToast(
          fToast: fToast,
          message: error,
          isError: true,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposer();
  }

  void _formSubmit() async {
    await loginStore.loginPressed().then((value) {
      if (value != null) {
        FocusScope.of(context).unfocus();
        Utils.showToast(
          fToast: fToast,
          message: 'Logado com sucesso!',
          isError: false,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BaseScreen(),
          ),
        );
      }else{
        FocusScope.of(context).unfocus();
        Utils.showToast(
          fToast: fToast,
          message: 'Ocorreu algum problema no seu login.',
          isError: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.sweet_cream,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(
                  'images/logo/MeuDoceCusto.png',
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bem-Vindo de volta! Que bom te ver por aqui.',
                  style: TextStyle(
                    fontSize: 14.5,
                    color: CustomColors.mint,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Observer(
                    builder: (_) {
                      return TextFormField(
                        onChanged: loginStore.setEmail,
                        style: const TextStyle(color: CustomColors.just_regular_brown),
                        cursorColor: CustomColors.just_regular_brown,
                        decoration: InputDecoration(
                          hintText: 'Email:',
                          hintStyle: const TextStyle(
                            color: CustomColors.mint,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          fillColor: CustomColors.mint.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Observer(
                    builder: (_) {
                      return TextFormField(
                        onChanged: loginStore.setPassword,
                        obscureText: loginStore.isObscure,
                        style: const TextStyle(color: CustomColors.just_regular_brown),
                        cursorColor: CustomColors.just_regular_brown,
                        onFieldSubmitted: (_) {
                          loginStore.invalidSendPressed();
                          loginStore.isFormValid ? _formSubmit() : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Senha:',
                          hintStyle: const TextStyle(
                            color: CustomColors.mint,
                            fontWeight: FontWeight.normal,
                          ),
                          filled: true,
                          fillColor: CustomColors.mint.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                loginStore.isObscure ? Icons.visibility_off : Icons.visibility,
                                color: CustomColors.mint,
                              ),
                            ),
                            onPressed: () {
                              loginStore.setIsObscure();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Observer(
                    builder: (_) {
                      return GestureDetector(
                        onTap: () => loginStore.invalidSendPressed(),
                        child: SizedBox(
                          height: 50,
                          width: screenSize.width,
                          child: ElevatedButton(
                            onPressed: loginStore.isFormValid ? _formSubmit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: loginStore.isFormValid ? CustomColors.gay_pink : Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: Center(
                              child: loginStore.loading ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: CustomColors.sweet_cream,
                                  strokeWidth: 3,
                                ),
                              ) : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: CustomColors.sweet_cream,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: 'Não possui uma conta? ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.mint,
                    ),
                    children: [
                      TextSpan(
                        text: 'Cadastre-se',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.gay_pink,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
