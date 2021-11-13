class LocationModel{
  String? name;
  String? formattedAddress;
  String? locality;
  String? postCode;
  double? latitude;
  String? city;
  String? state;
  String? country;
  double? longitude;
  LocationModel({this.name,this.city,this.state,this.formattedAddress,this.postCode,this.latitude,this.locality,this.longitude,this.country});
  LocationModel.fromJson(Map data):
      name=data['name'],
      formattedAddress=data['formatted_address'],
      locality=data['locality'],
      state=data['state'],
      city=data['city'],
      postCode=data['post_code'],
      latitude=data['latitude'],
      longitude=data['longitude'],
      country=data['country'];

  toMap(){
    return {
      "name":name,
      "formatted_address":formattedAddress,
      "locality":locality,
      "state":state,
      "city":city,
      "post_code":postCode,
      "latitude":latitude,
      "longitude":longitude,
      "country":country
    };
  }
}