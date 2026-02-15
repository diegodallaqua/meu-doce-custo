import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../global/theme/custom_colors.dart';
import '../global/theme/custom_sizes.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.title, this.actions, this.color, this.onBackButtonPressed})
      : preferredSize = const Size(double.infinity, CustomSizes.customAppBarHeight),
        super(key: key);

  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackButtonPressed;
  final Color? color;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final smallerThanTablet = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    final iconColor = smallerThanTablet ? CustomColors.mint : CustomColors.sweet_cream;

    return AppBar(
      backgroundColor: smallerThanTablet ? CustomColors.sweet_cream : CustomColors.gay_pink,
      elevation: smallerThanTablet ? 0 : 1,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: iconColor),
      title: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: CustomSizes.maxScreenWidth,
        ),
        child: Row(
          children: [
            if(onBackButtonPressed != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
              ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: smallerThanTablet ? CustomColors.mint : CustomColors.sweet_cream,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: actions != null ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
