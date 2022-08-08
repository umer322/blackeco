
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/core/controllers/reports_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/core/services/firebasedatabase_service.dart';
import 'package:blackeco/core/services/firebasestorage_service.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/core/services/location_service.dart';
import 'package:blackeco/core/services/multimedia_service.dart';
import 'package:blackeco/core/services/notification_service.dart';
import 'package:get/instance_manager.dart';

class ServicesBinder extends Bindings{
  @override
  void dependencies() {
      Get.lazyPut(() => FireBaseAuthService());
      Get.lazyPut(() => FireStoreService());
      Get.lazyPut(() => FireBaseStorageService());
      Get.lazyPut(() => FireBaseAuthService());
      Get.lazyPut(() => FireBaseDatabaseService());
      Get.lazyPut(() => ChatController());
      Get.put(UserController());
      Get.put(LocationService());
      Get.put(BusinessesController());
      Get.lazyPut(() => ReportsController());
      Get.lazyPut(() => MultiMediaService());
      Get.put(NotificationService());
  }
}