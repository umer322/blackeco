import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/routes.dart';
import 'package:blackeco/services_binder.dart';
import 'package:blackeco/ui/shared/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/controllers/user_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(LocalStorageService());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        setUserCurrentChatStatus();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  setUserCurrentChatStatus(){
    if(Get.find<UserController>().currentUser.value.id!=null &&Get.find<UserController>().currentUser.value.chattingWith!=null){
      Get.find<UserController>().currentUser.value.chattingWith=null;
      Get.find<UserController>().updateUserChatStatus({'chatting_with':null});
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onDispose: (){
        print("called this");
      },
      builder: (context,child){
        return GestureDetector(
          onTap: (){
            if(!FocusScope.of(context).hasPrimaryFocus){
              FocusScope.of(context).unfocus();
            }
          },
          child: child!,
        );
      },
      initialBinding: ServicesBinder(),
      getPages: Routes.pages,
      transitionDuration: Duration(milliseconds: 500),
      defaultTransition: Transition.fadeIn,
      theme:AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode:  Get.find<LocalStorageService>().getTheme()!=null?Get.find<LocalStorageService>().getTheme()=="light"?ThemeMode.light:ThemeMode.dark:ThemeMode.light,
      initialRoute: "/splash",
      debugShowCheckedModeBanner: false,
    );
  }
}

