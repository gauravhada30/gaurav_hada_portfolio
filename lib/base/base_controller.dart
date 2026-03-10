import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final RxBool isPageShow = false.obs;
  final RxBool isShowProgress = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isShowAppBar = false.obs;

  void showProgress() => isShowProgress.value = true;
  void hideProgress() => isShowProgress.value = false;

  void showPage() => isPageShow.value = true;
  void hidePage() => isPageShow.value = false;

  void showError(String message) {
    errorMessage.value = message;
    hideProgress();
  }
}
