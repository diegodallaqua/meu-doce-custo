import 'package:flutter/material.dart';
import '../../global/theme/custom_colors.dart';

class PageTile extends StatelessWidget {
  const PageTile({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTap,
    required this.highlighted,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: highlighted ? CustomColors.gay_pink.withOpacity(0.1) : null,
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: CustomColors.mint,
        fontWeight: FontWeight.w600,
        fontFamily: 'Nunito',
      ),
      title: Text(title),
      trailing: Icon(
        highlighted ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
        size: 18,
        color: CustomColors.mint,
      ),
      leading: Icon(
        iconData,
        color: CustomColors.mint,
      ),
      onTap: onTap,
    );
  }
}
