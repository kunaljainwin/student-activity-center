// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:samadhyan/constants.dart';

// String _showMainBanner = "show_main_banner";

// class RemoteConfigService {
//   late RemoteConfig _remoteConfig;

// // Getters for the values from the remote config
//   bool get showMainBanner => _remoteConfig.getBool(_showMainBanner);

//   var defaults = {_showMainBanner: false};
// //Constructor

// // Fetch the remote config values
//   Future<void> initialize() async {
//     try {
//       RemoteConfig remoteConfig = await RemoteConfig.instance;
//       _remoteConfig = remoteConfig;
//       await _remoteConfig.setDefaults(defaults);
//       await _fetchAndActivate();
//     } on FetchThrottledException catch (e) {
//       devMode == true
//           ? print(
//               "Remote config faced Throttling maybe due to Small Duration : $e")
//           : null;
//     } catch (e) {
//       devMode == true ? print(e) : null;
//     }
//   }

//   Future _fetchAndActivate() async {
//     await _remoteConfig.fetch(expiration: const Duration(hours: 1));
//     await _remoteConfig.activateFetched();
//   }
// }
