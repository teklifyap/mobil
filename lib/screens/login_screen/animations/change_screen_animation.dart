import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/screens/login_screen/components/login_content.dart';

class ChangeScreenAnimation {
  static late final AnimationController topTextController;
  static late final Animation<Offset> topTextAnimation;

  static late final AnimationController bottomTextController;
  static late final Animation<Offset> bottomTextAnimation;

  static late final AnimationController forgotPasswordController;
  static late final Animation<Offset> forgotPasswordAnimation;

  static final List<AnimationController> registerControllers = [];
  static final List<Animation<Offset>> registerAnimations = [];

  static final List<AnimationController> loginControllers = [];
  static final List<Animation<Offset>> loginAnimations = [];

  static final List<AnimationController> forgotPasswordControllers = [];
  static final List<Animation<Offset>> forgotPasswordAnimations = [];

  static var isPlaying = false;
  static var currentScreen = Screens.login;
  static bool hasBeenInitialized = false;

  static Animation<Offset> createCustomAnimation({
    required Offset begin,
    required Offset end,
    required AnimationController parent,
  }) {
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: Curves.easeInOut,
      ),
    );
  }

  static void initialize({
    required int registerItems,
    required int loginItems,
    required int forgotPasswordItems,
    required bool isReverse,
  }) {
    if (!isReverse) {
      topTextController = useAnimationController(
        duration: const Duration(milliseconds: 200),
      );

      topTextAnimation = createCustomAnimation(
        begin: Offset.zero,
        end: const Offset(-1.7, -1),
        parent: topTextController,
      );

      bottomTextController = useAnimationController(
        duration: const Duration(milliseconds: 200),
      );

      bottomTextAnimation = createCustomAnimation(
        begin: Offset.zero,
        end: const Offset(-1, 1.7),
        parent: bottomTextController,
      );

      forgotPasswordController = useAnimationController(
        duration: const Duration(milliseconds: 200),
      );

      forgotPasswordAnimation = createCustomAnimation(
        begin: Offset.zero,
        end: const Offset(0, 10),
        parent: forgotPasswordController,
      );
    }

    for (var i = 0; i < registerItems; i++) {
      registerControllers.add(
        useAnimationController(
          duration: const Duration(milliseconds: 200),
        ),
      );

      registerAnimations.add(
        createCustomAnimation(
          begin: const Offset(-1, 0),
          end: Offset.zero,
          parent: registerControllers[i],
        ),
      );
    }

    for (var i = 0; i < loginItems; i++) {
      loginControllers.add(
        useAnimationController(
          duration: const Duration(milliseconds: 200),
        ),
      );

      loginAnimations.add(
        createCustomAnimation(
          begin: Offset.zero,
          end: const Offset(1, 0),
          parent: loginControllers[i],
        ),
      );
    }

    for (var i = 0; i < forgotPasswordItems; i++) {
      forgotPasswordControllers.add(
        useAnimationController(
          duration: const Duration(milliseconds: 200),
        ),
      );

      forgotPasswordAnimations.add(
        createCustomAnimation(
          begin: const Offset(-1, 0),
          end: Offset.zero,
          parent: forgotPasswordControllers[i],
        ),
      );
    }

    hasBeenInitialized = true;
  }

  static void setCurrentScreen(Screens value) {
    currentScreen = value;
  }

  static Future<void> forward({bool isForgotPassword = false}) async {
    isPlaying = true;

    topTextController.forward();
    await bottomTextController.forward();

    if (isForgotPassword) {
      for (final controller in [
        ...loginControllers,
        ...forgotPasswordControllers,
      ]) {
        controller.forward();
        await Future.delayed(const Duration(milliseconds: 50));
      }
    } else {
      for (final controller in [
        ...loginControllers,
        ...registerControllers,
      ]) {
        controller.forward();
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    bottomTextController.reverse();
    await topTextController.reverse();

    isPlaying = false;
  }

  static Future<void> reverse() async {
    isPlaying = true;

    topTextController.forward();
    await bottomTextController.forward();

    for (final controller in [
      ...registerControllers.reversed,
      ...loginControllers.reversed,
    ]) {
      controller.reverse();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    bottomTextController.reverse();
    await topTextController.reverse();

    isPlaying = false;
  }
}
