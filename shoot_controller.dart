import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShootController extends GetxController {
  var time = "30:00".obs;
  var isBallVisible = false.obs;
  var ballOffsetY = 0.0.obs; // Ball's vertical position
  var isAnimating = false.obs;
  Timer? _timer;
  int _seconds = 30 * 60; // 30 minutes in seconds

  void onShootPressed(AnimationController animationController) {
    if (isAnimating.value) return; // Prevent multiple animations
    isAnimating.value = true;
    isBallVisible.value = true;

    // Reset ball position to behind Shoot button
    ballOffsetY.value = -10.0;

    // Start animation sequence
    animationController.reset();
    animationController.forward().then((_) {
      // After animation completes, hide ball and start timer
      isBallVisible.value = false;
      isAnimating.value = false;
      startTimer();
    });
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _seconds = 30 * 60; // Reset to 30 minutes
    updateTime();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        updateTime();
      } else {
        timer.cancel();
      }
    });
  }

  void updateTime() {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    time.value =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
