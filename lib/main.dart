import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/routes.dart';
import 'package:blackeco/services_binder.dart';
import 'package:blackeco/ui/shared/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(LocalStorageService());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
