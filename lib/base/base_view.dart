import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_controller.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  final T viewControl;
  final Widget Function(BuildContext context, T controller) onPageBuilder;

  const BaseView({
    super.key,
    required this.viewControl,
    required this.onPageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(viewControl);
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Main content
            AnimatedOpacity(
              opacity: controller.isPageShow.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: onPageBuilder(context, controller),
            ),
            // Loading overlay
            if (controller.isShowProgress.value)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
