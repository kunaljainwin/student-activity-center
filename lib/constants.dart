import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

const String app_name = "APP_NAME";
num error_distance = 10;
bool devMode = false;
bool subscription = false;
String userEmail = "";
// String userReferencePath = "";
// String passWord = "";
String userName = "";
// String userId = "";
// String userAbout = "";
String userContactNumber = "";
bool isLoggedIn = false;
String userFCMToken = "";
String userNewFCMToken = "";
// List<String> userHobbies = [];
// List<DocumentReference> userCart = [];
// int nNotifications = 1;
// List<DocumentReference> userBought = [];
// String userOccupation = "";
GeoPoint userLocation = GeoPoint(0, 0);
//if u add some var here please recheck with firebase operations AddUSer
// String userAddressLine1 = "";
String appLogo = "";
// String imageCongrats = "";
// String voice_gif = "";
// String mic_gif = "";
// String userAddressLine2 = "";
// String userCity = "";
// String userState = "";
// String userPincode = "";
// Timestamp userDob = Timestamp.now();
// bool isDarkMode = false;
// String userProfilePictureUrl = "";
// int loginType = 0;

