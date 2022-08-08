
import 'package:blackeco/models/location.dart';
import 'package:get/get.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/place_picker.dart';

class LocationService extends GetxService{


  Future<LocationModel?> getLocation()async {

    LocationResult? result = await Get.to(
            PlacePicker("AIzaSyBP2fP-UWcjp6QcM9dE2DeB96tlAJXgeRE"));

    if(result!=null){
      LocationModel location=LocationModel(name: result.name,city: result.city!.name,state:result.administrativeAreaLevel1!.name,formattedAddress: result.formattedAddress,locality: result.locality,country:result.country!.name,postCode: result.postalCode,latitude:result.latLng!.latitude,longitude: result.latLng!.longitude  );
      return location;
    }
    else{
      return null;
    }
    // Handle the result in your way
  }
}