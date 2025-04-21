import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shoot_controller.dart';

class ShootView extends GetView<ShootController> {
  const ShootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller outside build
    Get.lazyPut(() => ShootController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Time Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/ball.png',
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                          controller.time.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Digital',
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Robot Image and Ball Animation
              Stack(
                alignment: Alignment.center,
                children: [
                  // Robot Image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/robort.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Animated Ball
                  Obx(() {
                    return Positioned(
                      top: controller.ballOffsetY.value,
                      left: size.width / 2 - 20, // Center horizontally
                      child: AnimatedOpacity(
                        opacity: controller.isBallVisible.value &&
                                controller.ballOffsetY.value > -40
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: Image.asset(
                          'assets/images/ball.png',
                          height: 40,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              // "Tap Shoot to Talk"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ball.png', height: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'TAP SHOOT TO TALK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Shoot Button with Ball Stack
              Stack(
                alignment: Alignment.center,
                children: [
                  // Hidden Ball (initially behind button)
                  Obx(() => AnimatedOpacity(
                        opacity: controller.isBallVisible.value ? 0.0 : 0.0,
                        duration: const Duration(milliseconds: 100),
                        child: Image.asset(
                          'assets/images/ball.png',
                          height: 40,
                        ),
                      )),
                  // Shoot Button
                  GestureDetector(
                    onTap: () {
                      // Create AnimationController for each tap
                      AnimationController animationController =
                          AnimationController(
                        duration: const Duration(seconds: 2),
                        vsync: Navigator.of(context),
                      );

                      // Define animation sequence:
                      // 1. Up to top margin
                      // 2. Bounce to top of time badge
                      // 3. Bounce up off-screen
                      Animation<double> animation = TweenSequence<double>([
                        // Move to top margin (60% of animation)
                        TweenSequenceItem(
                          tween:
                              Tween<double>(begin: size.height * 0.6, end: 0),
                          weight: 60,
                        ),
                        // Bounce to top of time badge (20% of animation)
                        TweenSequenceItem(
                          tween: Tween<double>(begin: 0, end: 66),
                          weight: 20,
                        ),
                        // Move off-screen (20% of animation)
                        TweenSequenceItem(
                          tween: Tween<double>(begin: 66, end: -100),
                          weight: 20,
                        ),
                      ]).animate(CurvedAnimation(
                        parent: animationController,
                        curve: Curves.easeInOut,
                      ));

                      // Update ball position during animation
                      animation.addListener(() {
                        controller.ballOffsetY.value = animation.value;
                      });

                      controller.onShootPressed(animationController);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF1F1F1F), Color(0xFF2B2B2B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/voice.png', height: 36),
                          const SizedBox(height: 8),
                          const Text(
                            'SHOOT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
