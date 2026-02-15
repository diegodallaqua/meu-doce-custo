import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meu_doce_custo/features/brand/models/brand.dart';

import '../../../../core/global/theme/custom_colors.dart';
import '../create_brand_screen.dart';

class BrandTile extends StatelessWidget {
  const BrandTile({Key? key, required this.brand}) : super(key: key);

  final Brand brand;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      //padding: const EdgeInsets.symmetric(vertical: 4),
      title: Text(
        brand.name!,
        style: TextStyle(
          color: CustomColors.just_regular_brown.withOpacity(0.8),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateBrandScreen(brand: brand),
              )
          );
        },
        icon: Icon(
          Icons.edit,
          color: CustomColors.just_regular_brown.withOpacity(0.8),
        ),
      ),
    );
  }
}
