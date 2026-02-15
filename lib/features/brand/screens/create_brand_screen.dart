import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:meu_doce_custo/features/brand/models/brand.dart';
import 'package:mobx/mobx.dart';

import '../../../core/global/theme/custom_colors.dart';
import '../../../core/ui/body_container.dart';
import '../../../core/ui/custom_app_bar.dart';
import '../../../core/ui/custom_form_field.dart';
import '../../../core/ui/patterned_buttom.dart';
import '../../../core/ui/title_text_form.dart';
import '../stores/create_brand_store.dart';
import '../stores/brand_store.dart';
import 'brand_screen.dart';

class CreateBrandScreen extends StatefulWidget {
  const CreateBrandScreen({Key? key, this.brand}) : super(key: key);

  final Brand? brand;

  @override
  State<CreateBrandScreen> createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  late bool editing;
  late final CreateBrandStore createBrandStore;
  final brandStore = GetIt.I<BrandStore>();
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    editing = widget.brand != null;
    createBrandStore = CreateBrandStore(widget.brand);

    //QUANDO SALVAR COM SUCESSO, VOLTA PARA A TELA ANTERIOR E RECARREGA OS DADOS
    when((_) => createBrandStore.savedOrUpdatedOrDeleted, () {
      brandStore.refreshData();
      backToPreviousScreen();
    });

    reactionDisposer = reaction((_) => createBrandStore.error, (error) {
      if (error != null) {
        print(error);
      }
    });
  }

  //Ao sair do widget
  @override
  void dispose() {
    reactionDisposer();
    super.dispose();
  }

  void backToPreviousScreen() {
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => BrandScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        title: editing ? 'Editar Marca' : 'Cadastrar Marca',
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
                              TitleTextForm(title: 'Nome da Marca'),
                              Observer(
                                builder: (context) => CustomFormField(
                                  initialvalue: createBrandStore.name,
                                  onChanged: createBrandStore.setName,
                                  error: createBrandStore.nameError,
                                  secret: false,
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
                    child: editing ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: PatternedButton(
                            color: CustomColors.sweet_cream,
                            textColor: CustomColors.lipstick_pink,
                            text: 'Excluir',
                            largura: screenSize.width * 0.3,
                            function: editing ? () async {
                              await createBrandStore.deleteBrand();
                            } : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 6,
                          child: Observer(
                            builder: (context) => GestureDetector(
                              onTap: () => createBrandStore.invalidSendPressed(),
                              child: PatternedButton(
                                color: CustomColors.gay_pink,
                                text: 'Salvar',
                                largura: screenSize.width * 0.65,
                                function: createBrandStore.isFormValid ? () async {
                                  if (editing) {
                                    await createBrandStore.editPressed();
                                  } else {
                                    await createBrandStore.createPressed();
                                  }
                                } : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Observer(
                            builder: (context) => GestureDetector(
                              onTap: () => createBrandStore.invalidSendPressed(),
                              child: PatternedButton(
                                color: CustomColors.gay_pink,
                                text: 'Salvar',
                                largura: screenSize.width * 0.95,
                                function: createBrandStore.isFormValid ? () async {
                                  if (editing) {
                                    await createBrandStore.editPressed();
                                  } else {
                                    await createBrandStore.createPressed();
                                  }
                                } : null,
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
