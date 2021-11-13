class SocialMediaData{
  String? icon;
  String? url;
  String? name;
  SocialMediaData({this.icon,this.url,this.name});

  SocialMediaData.fromJson(Map<String,dynamic> data):
      icon=data['icon'],
      url=data['url'],
      name=data['name'];

  toMap(){
    return {
      "icon":icon,
      "url":url,
      "name":name
    };
  }


  static List mediaSitesDropdown = [{
    "name":"Facebook",
    "icon":"assets/icons/facebook.png"
  },
    {
      "name":"Instagram",
      "icon":"assets/icons/instagram.png"
    },
    {
      "name":"Twitter",
      "icon":"assets/icons/twitter.png"
    },
    {
      "name":"Pinterest",
      "icon":"assets/icons/pinterest.png"
    }];
}