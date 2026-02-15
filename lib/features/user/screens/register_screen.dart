import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../core/global/theme/custom_colors.dart';
import '../../../../core/ui/body_container.dart';
import '../../../../core/ui/custom_app_bar.dart';
import '../../../../core/ui/custom_form_field.dart';
import '../../../../core/ui/patterned_buttom.dart';
import '../../../../core/ui/title_text_form.dart';
import '../../../core/ui/password_divider.dart';
import '../../auth/screens/login_screen.dart';
import '../stores/create_user_store.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final CreateUserStore createUserStore = CreateUserStore();
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();

    // QUANDO SALVAR COM SUCESSO, VOLTA PARA A TELA ANTERIOR E RECARREGA OS DADOS
    when((_) => createUserStore.savedOrUpdatedOrDeleted, () {
      backToPreviousScreen();
    });

    reactionDisposer = reaction((_) => createUserStore.error, (error) {
      if (error != null) {
        print(error);
      }
    });
  }

  // Ao sair do widget
  @override
  void dispose() {
    reactionDisposer();
    super.dispose();
  }

  void backToPreviousScreen() {
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cadastro',
        onBackButtonPressed: backToPreviousScreen,
      ),
      body: BodyContainer(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: GlowingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        color: CustomColors.gay_pink,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 15),
                              TitleTextForm(title: 'Digite seu Nome'),
                              Observer(
                                builder: (context) => CustomFormField(
                                  initialvalue: createUserStore.name,
                                  onChanged: createUserStore.setName,
                                  textInputAction: TextInputAction.next,
                                  error: createUserStore.nameError,
                                  secret: false,
                                ),
                              ),
                              TitleTextForm(title: 'Digite seu E-mail'),
                              Observer(
                                builder: (context) => CustomFormField(
                                  initialvalue: createUserStore.email,
                                  onChanged: createUserStore.setEmail,
                                  typeKeyboard: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  error: createUserStore.emailError,
                                  secret: false,
                                ),
                              ),

                              const PasswordDivider(),

                              const SizedBox(height: 8),
                              TitleTextForm (title: 'Senha *'),
                              Observer(
                                builder: (context) => CustomFormField(
                                  initialvalue: createUserStore.password,
                                  onChanged: createUserStore.setPassword,
                                  textInputAction: TextInputAction.next,
                                  error: createUserStore.passwordError,
                                  visible: createUserStore.visiblePassword,
                                  set_visible: createUserStore.setObscurePassword,
                                  secret: true,
                                ),
                              ),

                              TitleTextForm (title: 'Confirme a Senha *'),
                              Observer(
                                builder: (context) => CustomFormField(
                                  set_visible: createUserStore.setObscurePasswordConfirmation,
                                  visible: createUserStore.visiblePasswordConfirmation,
                                  initialvalue: createUserStore.password_confirmation,
                                  onChanged: createUserStore.setPasswordConfirmation,
                                  typeKeyboard: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  error: createUserStore.showErrors ? createUserStore.passwordConfirmationError : null,
                                  secret: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Observer(
                            builder: (context) => GestureDetector(
                              onTap: () => createUserStore.invalidSendPressed(),
                              child: PatternedButton(
                                color: CustomColors.gay_pink,
                                text: 'Salvar',
                                largura: screenSize.width * 0.95,
                                function: createUserStore.isFormValid ? () async {
                                  await createUserStore.createPressed();
                                } : null
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
