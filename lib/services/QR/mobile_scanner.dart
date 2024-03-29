import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/Services/mongo.dart';
import 'package:samadhyan/widgets/login_helpers.dart';

class Scanner extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const Scanner({
    super.key,
    required this.documentSnapshot,
  });

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  // late FToast fToast;

  @override
  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast.init(context);
  }

  // _showToast(Color color, String message) {

  // Widget toast = Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(25.0),
  //     color: color,
  //   ),
  //   child: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(Icons.check),
  //       SizedBox(
  //         width: 12.0,
  //       ),
  //       Text(message),
  //     ],
  //   ),
  // );

  // fToast.showToast(
  //   child: toast,
  //   gravity: ToastGravity.BOTTOM,
  //   toastDuration: Duration(seconds: 2),
  // );

  // Custom Toast Position
  // fToast.showToast(
  //     child: toast,
  //     toastDuration: Duration(seconds: 2),
  //     positionedToastBuilder: (context, child) {
  //       return Positioned(
  //         child: child,
  //         top: 16.0,
  //         left: 16.0,
  //       );
  //     });
  // }

  MobileScannerController _ScannerController = MobileScannerController();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ScaffoldMessenger.of(context).clearSnackBars();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.documentSnapshot['title']),
          actions: [
            IconButton(
              iconSize: 32,
              onPressed: (() => _ScannerController.toggleTorch()),
              icon: ValueListenableBuilder(
                valueListenable: _ScannerController.torchState,
                builder: (context, state, child) {
                  return Icon(state == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off);
                },
              ),
            ),
            IconButton(
              iconSize: 32,
              onPressed: (() => _ScannerController.switchCamera()),
              icon: ValueListenableBuilder(
                valueListenable: _ScannerController.cameraFacingState,
                builder: (context, value, child) => Icon(
                  value == CameraFacing.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                ),
              ),
            ),
          ],
        ),
        body: MobileScanner(
          allowDuplicates: false,
          controller: _ScannerController,
          onDetect: (result, type) async {
            if (_isScanning) {
              _isScanning = false;
              String output = result.rawValue ?? "";
              if (widget.documentSnapshot['registered'].contains(output) &&
                  widget.documentSnapshot['startTime']
                          .toDate()
                          .compareTo(DateTime.now()) <=
                      0 &&
                  widget.documentSnapshot['endTime']
                          .toDate()
                          .compareTo(DateTime.now()) >
                      0) {
                // MongoDB.insertData({
                //   '_id': widget.documentSnapshot.id,
                //   'attendees': FieldValue.arrayUnion([
                //     {
                //       // 'name':
                //       'email': result.rawValue,
                //       'time': DateTime.now(),
                //     }
                //   ]),
                //   // Need to code here to insert data into the database
                // });
                widget.documentSnapshot.reference.update(
                  {
                    'attendees': FieldValue.arrayUnion([output]),
                  },
                );

                FirebaseFirestore.instance
                    .collection("users")
                    .where('useremail', isEqualTo: output)
                    .limit(1)
                    .get()
                    .then((value) => {
                          value.docs[0].reference
                              .update({'attendance': FieldValue.increment(1)})
                        });
                Fluttertoast.showToast(
                    backgroundColor: Colors.green, msg: "successfully scanned");
              } else if (widget.documentSnapshot['attendees']
                  .contains(result.rawValue)) {
                Fluttertoast.showToast(
                    backgroundColor: Colors.blue,
                    msg: "Already Scanned and attended");
              } else {
                Fluttertoast.showToast(
                    backgroundColor: Colors.red,
                    msg: output + "Not Registered or Early/Late for the event");
              }

              _isScanning = true;
            }
          },
        ),
      ),
    );
  }
}
