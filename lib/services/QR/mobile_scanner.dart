import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:samadhyan/constants.dart';
import 'package:samadhyan/Services/mongo.dart';

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
          title: const Text('Mobile Scanner'),
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
          allowDuplicates: true,
          controller: _ScannerController,
          onDetect: (result, type) async {
            if (_isScanning) {
              _isScanning = false;
              if (widget.documentSnapshot['attendees']
                  .contains(result.rawValue)) {
                Fluttertoast.showToast(
                    backgroundColor: Colors.blue,
                    msg: "Already Scanned and attended");
              } else if (widget.documentSnapshot['registered']
                      .contains(result.rawValue) &&
                  widget.documentSnapshot['startTime']
                          .toDate()
                          .compareTo(DateTime.now()) <=
                      0 &&
                  widget.documentSnapshot['endTime']
                          .toDate()
                          .compareTo(DateTime.now()) >
                      0) {
                // await MongoDB.insertData({
                //   // Need to code here to insert data into the database
                // });
                await widget.documentSnapshot.reference.update(
                  {
                    // 'registered': FieldValue.arrayRemove([userEmail]),
                    'attendees': FieldValue.arrayUnion([result.rawValue]),
                  },
                );
                Fluttertoast.showToast(
                    backgroundColor: Colors.green,
                    msg: 'Marked his attendance');
              } else {
                Fluttertoast.showToast(
                    backgroundColor: Colors.red,
                    msg: "Not Registered or Early/Late for the event");
              }

              _isScanning = true;
            }
          },
        ),
      ),
    );
  }
}
