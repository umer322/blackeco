import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AutoSizeText("About Us"),),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(Get.width*0.05),
          child: Column(
            children: [
              AutoSizeText("In a vastly diverse city such as Toronto, it is sometimes extremely difficult to find and support businesses or services owned by people of the African diaspora. Although Toronto is filled with these businesses/services, Googling “Black dentists in Toronto” more than likely won't garner the results you would hope for.\n\n",textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],),
              AutoSizeText('This was a problem a colleague and I realized when we went in search for a black family doctor. We did our "Google’s", we searched through directories, checked black business groups online, and asked family, friends, and co-workers. It was a long tedious process for a task we believed should have been effortless. We began to realize that supporting black owned businesses in general was not as straightforward as we thought it should be, merely because finding them was a trivial bout in itself.\n\n',textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],),
              AutoSizeText("This is when we decided we would create an app that would bring the convenience we were looking for. We went to the drawing board and came up with ideas we thought the community would want to see. Then we set out to look for black developers. Our first major obstacle. We looked on many platforms and could not find any, but knew they existed. This was a prime example of wanting to support your community but not having the tools to do so. We managed to find developers who were not what we were looking for but were dedicated to making our idea become a reality.\n\n",textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],),
              AutoSizeText("At the completion of the BlackEco platform, we now have a space where black-owned businesses and services can connect with consumers looking for black-owned establishments anywhere in the world. This allows for the dollar to stay within the black community longer, and as a result, strengthening the black economy.\n\n",textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],),
              AutoSizeText("Furthermore, it is ran by the people. Anyone is able to add businesses to the directory. This allows for all types of businesses and services to become accessible to the community instantly.\n\n",textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],),
              AutoSizeText("Despite the long journey, the potential for the community to become stronger, wealthier and more united has made the entire process worth it.\n\n",textAlign: TextAlign.justify,presetFontSizes: [FontSizes.s16],)
            ],
          ),
        ),
      ),
    );
  }
}
