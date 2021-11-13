import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CategoryModel{
  int? id;
  String? name;
  SvgPicture? image;
  List<String>? subCategories;
  CategoryModel({this.name,this.image,this.subCategories,this.id});

  static List<CategoryModel> allCategoriesList =[
    CategoryModel(
        id: 0,
        name: "Beauty",image: SvgPicture.asset("assets/beauty.svg",height: Get.height*0.05,width: Get.height*0.05,)),
    CategoryModel(
        id: 1,
        name: "Food",image: SvgPicture.asset("assets/food.svg",height: Get.height*0.05,width: Get.height*0.05,)),
    CategoryModel(
        id: 2,
        name: "Health & Medical",image: SvgPicture.asset("assets/health.svg",height: Get.height*0.05,width: Get.height*0.05,)),
    CategoryModel(
        id: 3,
        name: "Automotive",image: SvgPicture.asset("assets/automotive.svg",height: Get.height*0.03,width: Get.height*0.03,)),
    CategoryModel(
        id: 4,
        name: "Apparel & Accessories",image: SvgPicture.asset("assets/apparel.svg",height: Get.height*0.05,width: Get.height*0.05,)),
  ];

  static List<String> categories=["Apparel & Accessories","Arts & Entertainment","Automotive","Beauty","Education","Events","Financial Services","Food","Health & Medical","Home Services","Professional Services","Religious Organizations"];
  static List<String> apparelSubCategories=['Clothing','Shoes','Jewelery','Accessories','Other'];
  static List<String> artSubCategories=['Musicians','Visual artists','Other'];
  static List<String> automotiveSubCategories=['Auto Detailing','Auto Repair','Tires','Towing','Renters','Other'];
  static List<String> beautySubCategories=['Beauty Treatments','Barbers','Beauty Supply','Cosmetics','Dental Services','Eyelash + Eyebrow Services','Hair Services','Makeup Artists','Massage','Nail Services', 'Tattoo','Other'];
  static List<String> educationSubCategories=['Classes', 'Tutor','Schools','Other'];
  static List<String> eventSubCategories=['Caterers', 'Decorations','DJs', 'Face Painting', 'Party & Event Planning', 'Photographers', 'MCs', 'Venues', 'Videographers', 'Other'];
  static List<String> financialSubCategories=['Accountants', 'Financial Advising', 'Insurance', 'Investing', 'Tax Services', 'Other'];
  static List<String> foodSubCategories=['Baked Goods', 'Drinks', 'African', 'Carribean', 'Vegan & Vegetarian','Other'];
  static List<String> healthSubCategories=['Counselling & Mental Health', 'Dentists', 'Dietition', 'Doctors', 'Doulas', 'Massage Therapy', 'Midwives', 'Other'];
  static List<String> homeSubCategories=['Carpenters', 'Drywall Installation & Repair', 'Electricians', 'Fences & Gates', 'Flooring', 'Handyman', 'Interior Design', 'Painter', 'Other'];
  static List<String> professionalSubCategories=['Advertising', 'App Developers', 'Cleaners', 'Commissioned Artists', 'Graphic Design', 'Lawyers', 'Marketing', 'Models', 'Music Production Services', 'Real Estate', 'Security Services', 'Web Design', 'Other'];
  static List<String> religiousSubCategories=['Churches', 'Mosques', 'Other'];


  static List<String>? returnSubCategory(String category){
    switch(category){
      case "Apparel & Accessories":
        return apparelSubCategories;
      case "Arts & Entertainment":
        return artSubCategories;
      case  "Automotive":
        return automotiveSubCategories;
      case  "Beauty":
        return beautySubCategories;
      case "Education":
        return educationSubCategories;
      case "Events":
        return eventSubCategories;
      case  "Financial Services":
        return financialSubCategories;
      case "Food":
        return foodSubCategories;
      case "Health & Medical":
        return healthSubCategories;
      case "Home Services":
        return homeSubCategories;
      case "Professional Services":
        return professionalSubCategories;
      case "Religious Organizations":
        return religiousSubCategories;
      default:
        return null;
    }
  }
}