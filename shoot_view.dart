import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shoot_controller.dart';

class ShootView extends StatefulWidget {
  const ShootView({Key? key}) : super(key: key);

  @override
  _ShootViewState createState() => _ShootViewState();
}

class _ShootViewState extends State<ShootView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _badgeBallController;
  late Animation<double> _badgeBallAnimation;
  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800), // Reduced for snappier feel
      vsync: this,
    );
    _badgeBallController = AnimationController(
      duration: const Duration(milliseconds: 300), // Short for quick bounce
      vsync: this,
    );
    // Initialize controller outside build
    Get.lazyPut(() => ShootController());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShootController>();
    final size = MediaQuery.of(context).size;

    // Define animation only once
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: size.height - 180, // Start behind Shoot button
          end: 50, // Near badge
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 50,
          end: 80, // Small bounce back down
        ),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 80,
          end: 60, // Bounce up slightly
        ),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 60,
          end: -40, // Disappear off-screen
        ),
        weight: 15,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // Smoother curve for natural motion
      ),
    );

    // Add listener once
    _animationController.removeListener(() {}); // Clear previous listeners
    _animation.addListener(() {
      controller.ballOffsetY.value = _animation.value;
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
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
                        Image.asset('assets/images/ball.png', height: 24),
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
                  // Robot Image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/robort.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // "TAP SHOOT TO TALK"
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
                  // Shoot Button
                  GestureDetector(
                    onTap: () {
                      controller.onShootPressed(_animationController);
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Animated Ball
          Obx(() {
            return Positioned(
              top: controller.ballOffsetY.value,
              left: size.width / 2 - 20, // Adjust for ball width
              child: AnimatedOpacity(
                opacity: controller.isBallVisible.value &&
                        controller.ballOffsetY.value > -40
                    ? 1.0
                    : 0.0,
                duration: const Duration(milliseconds: 200), // Smoother fade
                child: Image.asset(
                  'assets/images/ball.png',
                  height: 90,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
