

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalStorageService extends GetxService{




  late GetStorage box;


  addBusinessToRecentSearch(String id){
    List<Map> searches=List<Map>.from(box.read("recent")??[]);
    searches.insert(0,{"id":id,"time":DateTime.now().toString()});
    box.write("recent", searches.toSet().toList());
  }

  getLocation(){
    return box.read("location")??{};
  }

  setLocation(Map data){
    box.write("location",data);
  }

  String? get getFirst=>box.read("first");

  List<Map> getRecentSearches(){
    return List<Map>.from(box.read("recent")??[]);
  }

  setTheme(String value){
    box.write("theme", value);
  }

  getTheme(){
    return box.read("theme");
  }


  void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';



  Future<String> createBusinessLink(String businessId)async{
    final DynamicLinkParameters parameters=DynamicLinkParameters(uriPrefix: "https://blackeco.page.link",
      link: Uri.parse("https://blackeco.com/businsess/$businessId"),
      androidParameters: AndroidParameters(
        packageName: 'com.blackeco.blackeco',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.blackeco.blackeco',
        minimumVersion: '1.0.0',
      ),
    );

    final ShortDynamicLink dynamicLink=await parameters.buildShortLink();

    final Uri shortUrl = dynamicLink.shortUrl;

    return shortUrl.toString();
  }

  @override
  void onInit() {
    box=GetStorage();
    super.onInit();
  }

}