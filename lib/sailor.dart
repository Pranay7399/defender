import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Sailor {
  static Future<dynamic>? push(Widget child, {Transition? transition}) {
    _setTransition(transition);
    return Get.to(child);
  }

  static Future<dynamic>? pushNamed(
    String child, {
    dynamic arguments,
    int? id,
    Transition? transition,
  }) {
    _setTransition(transition);
    return Get.toNamed(child, arguments: arguments, id: id);
  }

  static Future<dynamic>? pushWidget(Widget child, {Transition? transition}) {
    _setTransition(transition);
    return Get.to(child);
  }

  static Future<dynamic>? replaceStackWith(Widget child,
      {Transition? transition}) {
    _setTransition(transition);
    return Get.offAll(child);
  }

  static Future<dynamic>? replaceStackWithNamed(String child,
      {Transition? transition}) {
    _setTransition(transition);
    return Get.offAllNamed(child);
  }

  static Future<dynamic>? replaceStackWithWidget(Widget child,
      {Transition? transition}) {
    _setTransition(transition);
    return Get.offAll(child);
  }

  static void pop({dynamic result, Transition? transition}) {
    _setTransition(transition);
    Get.back(result: result);
  }

  static void popForced({dynamic result, Transition? transition}) {
    _setTransition(transition);
    Get.back(result: result);
  }

  static void popModal() {
    Get.back();
  }

  static void popBottomsheet() {
    Get.back();
  }

  static void popUntil(String routeName, {Transition? transition}) {
    _setTransition(transition);
    bool canPop = false;
    Get.until((route) {
      if (route.settings.name == routeName) {
        canPop = true;
        return true;
      }
      return false;
    });
    if (!canPop) {
      Sailor.replaceStackWithNamed('');
    }
  }

  static void replaceWithWidget(Widget child, {Transition? transition}) {
    _setTransition(transition);
    Get.off(child);
  }

  static void replaceWithNamed(String routeName, {Transition? transition}) {
    _setTransition(transition);
    Get.offNamed(routeName);
  }

  static void _setTransition(Transition? transition) {
    Get.config(
      defaultTransition: transition ?? Transition.native,
    );
  }
}
