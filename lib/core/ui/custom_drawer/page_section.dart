import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import '../../../features/auth/screens/login_screen.dart';
import '../../../app/shell/stores/page_store.dart';
import '../../../features/user/stores/user_manager_store.dart';
import 'page_tile.dart';

class PageSection extends StatelessWidget {
  PageSection({Key? key, required this.navigateToPage}) : super(key: key);

  final pageStore = GetIt.I<PageStore>();
  final userManagerStore = GetIt.I<UserManagerStore>();
  final Function navigateToPage;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageTile(
            title: 'Receitas',
            iconData: Icons.book,
            highlighted: pageStore.page == 0,
            onTap: () {
              navigateToPage(pageIndex: 0, context: context);
            },
          ),
          PageTile(
            title: 'Ingredientes',
            iconData: Icons.kitchen,
            highlighted: pageStore.page == 1,
            onTap: () {
              navigateToPage(pageIndex: 1, context: context);
            },
          ),
          PageTile(
            title: 'Marcas',
            iconData: Icons.store,
            highlighted: pageStore.page == 2,
            onTap: () {
              navigateToPage(pageIndex: 2, context: context);
            },
          ),
          PageTile(
            title: 'Sair',
            iconData: Icons.exit_to_app,
            highlighted: false,
            onTap: () async {
              await userManagerStore.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
