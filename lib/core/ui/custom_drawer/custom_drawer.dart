import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../app/shell/stores/page_store.dart';
import '../../global/theme/custom_colors.dart';
import 'drawer_header.dart';
import 'page_section.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final pageStore = GetIt.I<PageStore>();

  void navigateToPage({required int pageIndex, required BuildContext context}) {
    Navigator.of(context).pop();
    pageStore.setPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: CustomColors.sweet_cream,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const CustomDrawerHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                PageSection(navigateToPage: navigateToPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
