import 'package:cloud_firestore/cloud_firestore.dart';

bool isProfileComplete(DocumentSnapshot snapshot) {
  if (snapshot["nickname"] == null || snapshot["nickname"] == "") {
    return false;
  }
  // if(snapshot["phone"] == null || snapshot["phone"] == ""){
  //   return false;
  // }
  if (snapshot["secondemail"] == null || snapshot["secondemail"] == "") {
    return false;
  }
  // if(snapshot["address"] == null || snapshot["address"] == ""){
  //   return false;
  // }
  // if(snapshot["city"] == null || snapshot["city"] == ""){
  //   return false;
  // }
  // if(snapshot["state"] == null || snapshot["state"] == ""){
  //   return false;
  // }
  // if(snapshot["pincode"] == null || snapshot["pincode"] == ""){
  //   return false;
  // }
  // if(snapshot["dob"] == null || snapshot["dob"] == ""){
  //   return false;
  // }
  return true;
}
