import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme/custom_colors.dart';

class Utils {
  static void showToast({
    required FToast fToast,
    required String message,
    bool isError = false,
  }) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isError ? CustomColors.lipstick_pink : CustomColors.just_regular_brown,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? Icons.close : Icons.check,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: const TextStyle(
              color: CustomColors.sweet_cream,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  static void openCalendar({
    DateTime? initialDate,
    required Function(DateTime) setDateFunction,
    DateTime? firstDate,
    DateTime? lastDate,
    required BuildContext context,
  }) {
    var today = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: initialDate ?? today,
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.mint,
              onSurface: CustomColors.mint,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.just_regular_brown,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setDateFunction(pickedDate);
    });
  }
}
