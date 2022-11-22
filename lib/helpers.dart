import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

enum SnackType {
  success,
  info,
  error,
}

extension SnackTypeData on SnackType {
  Icon get icon {
    switch (this) {
      case SnackType.error:
        return const Icon(
          Icons.error,
          color: Colors.white,
        );
      case SnackType.success:
        return const Icon(Icons.check_circle, color: Colors.white);
      default:
        return const Icon(
          Icons.info,
          color: Colors.white,
        );
    }
  }

  Color get bgColor {
    switch (this) {
      case SnackType.error:
        return Colors.red.withOpacity(0.9);
      case SnackType.success:
        return Colors.green.withOpacity(0.9);
      default:
        return Colors.black.withOpacity(0.9);
    }
  }

  String get typeLabel {
    switch (this) {
      case SnackType.error:
        return 'Error';
      case SnackType.success:
        return 'Success';
      default:
        return 'Warning';
    }
  }
}

const TextStyle snackTitle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w700,
  fontSize: 16,
  fontFamily: 'poppins',
);

const TextStyle snackDescription = TextStyle(
  color: Colors.white,
  fontFamily: 'poppins',
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

void showSnackBar(
    {required String title,
    Icon? icon,
    Color? color,
    Duration duration = const Duration(seconds: 2),
    SnackType type = SnackType.info,
    BuildContext? context,
    String? message,
    String? typeLabel,
    bool showProgressIndicator = false,
    Key? key}) {
  showFlash(
    context: context ?? Get.find<GlobalKey<NavigatorState>>().currentContext!,
    duration: duration,
    transitionDuration: const Duration(milliseconds: 350),
    builder: (context, controller) {
      return Flash(
        key: key,
        useSafeArea: true,
        controller: controller,
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        margin: const EdgeInsets.all(20),
        boxShadows: kElevationToShadow[6],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        backgroundColor: color ?? type.bgColor,
        borderRadius: BorderRadius.circular(12),
        child: FlashBar(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          icon: icon ?? type.icon,
          progressIndicatorBackgroundColor: Colors.grey[400],
          showProgressIndicator: showProgressIndicator,
          content: Text(
            title,
            style: snackDescription,
          ),
        ),
      );
    },
  );
}
