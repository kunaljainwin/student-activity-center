import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:samadhyan/role_based/common/drawer.dart';

import 'package:samadhyan/widgets/title_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  static String title = "";
  static String description = "";
  static String location = "";
  static DateTime lastRegisterationTime = DateTime.now();
  static DateTime startTime = DateTime.now();
  static DateTime endTime = DateTime.now();
  static String eventCoordinator = userName;
  static String eventCoordinatorEmail = userEmail;
  static String eventCoordinatorPhone = userContactNumber;
  static String eventCoordinatorPassword = "";
  static String announcement = "";
  static String importantNote = "";
  static String eventPosterLink = urlLogo;
  static String clubName = "";
  static String socialMediaLinkForUpdates = "";

  static Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    title = prefs.getString('title') ?? '';
    description = prefs.getString('description') ?? '';
    location = prefs.getString('location') ?? '';
    // String startDate="";
    // String endDate="";
    // String lastRegisterationTime="";
    eventCoordinator = prefs.getString('eventCoordinator') ?? '';
    eventCoordinatorEmail = prefs.getString('eventCoordinatorEmail') ?? '';
    eventCoordinatorPhone = prefs.getString('eventCoordinatorPhone') ?? '';
    String eventCoordinatorId = "";
    // String eventCoordinatorImage="";
    // String eventCoordinatorType="";
    announcement = prefs.getString('announcement') ?? '';
    importantNote = prefs.getString('importantNote') ?? '';
    eventPosterLink = prefs.getString('eventPosterLink') ?? '';
    clubName = prefs.getString('clubName') ?? '';
    socialMediaLinkForUpdates = prefs.getString('socialMedia') ?? '';
  }

  Future<String> pickEventPoster(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
          allowCompression: true,
          lockParentWindow: true);

      if (result != null) {
        _fileBytes = result.files.first.bytes!;
        if (_fileBytes != null) {
          _fileName = result.files.first.name;
          isImageSelected = true;
        } else {
          // fail to convert files to bytes toast message
          Fluttertoast.showToast(msg: "File is empty");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
    }

    return urlLogo;
  }

  Future uploadArt(Uint8List poster, String fileName) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('files/$userEmail/$fileName/${TimeOfDay.now()}');
    UploadTask sampleArtUploadTask = reference.putData(poster);
    String url = await (await sampleArtUploadTask).ref.getDownloadURL();
    return url;
  }
  //  Future uploadArt(File poster) async {
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child('files/$userEmail/${poster.path}/${TimeOfDay.now()}');
  //   UploadTask sampleArtUploadTask = reference.putFile(poster);
  //   String url = await (await sampleArtUploadTask).ref.getDownloadURL();
  //   return url;
  // }

  static Future submitData() async {
    // send to server
    FirebaseFirestore.instance.collection("contests").doc().set({
      "title": title,
      "description": description,
      "location": location,
      "lastRegisterationTime": lastRegisterationTime,
      "startTime": startTime,
      "endTime": endTime,
      "eventCoordinator": eventCoordinator,
      "eventCoordinatorEmail": eventCoordinatorEmail,
      "eventCoordinatorPhone": eventCoordinatorPhone,
      "announcement": announcement,
      "importantNote": importantNote,
      "eventPosterLink": eventPosterLink,
      "clubName": clubName,
      "socialMediaLinkForUpdates": socialMediaLinkForUpdates,
      "attendees": [],
      "creationTime": DateTime.now(),
      "registered": [],
    });

    // store updated data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('title', title);
    prefs.setString('description', description);
    prefs.setString('location', location);
    prefs.setString('eventCoordinator', eventCoordinator);
    prefs.setString('eventCoordinatorEmail', eventCoordinatorEmail);
    prefs.setString('eventCoordinatorPhone', eventCoordinatorPhone);
    prefs.setString('eventCoordinatorId', userEmail);

    prefs.setString('announcement', announcement);
    prefs.setString('importantNote', importantNote);
    prefs.setString('eventPosterLink', eventPosterLink);

    // create event in MongoDB
  }

  @override
  void initState() {
    // TODO: implement initState
    getData().whenComplete(() => setState(() {}));
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isImageSelected = false;
  late Uint8List _fileBytes;
  late String _fileName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
          key: _formKey,
          onWillPop: () async {
            bool flag = true;
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("Are you sure you want to exit?"),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("Yes"),
                        onPressed: () {
                          flag = true;
                          Get.back();
                          Get.back();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("No"),
                        onPressed: () {
                          flag = false;
                          Get.back();
                        },
                      ),
                    ],
                  );
                });
            // flag ? Get.back() : null;
            return flag;
          },
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                titleBox("Event Poster"),
                //edit
                //remove
                isImageSelected
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                              onTap: () async {},
                              child: Image.memory(
                                _fileBytes,
                                errorBuilder: ((context, error, stackTrace) =>
                                    const Text("Error loading image")),
                                frameBuilder: ((context, child, frame,
                                        wasSynchronouslyLoaded) =>
                                    frame == null
                                        ? const Center(
                                            child:
                                                const CircularProgressIndicator(),
                                          )
                                        : child),
                              )),
                          ActionChip(
                              label: const Text("Change"),
                              avatar: const Icon(Icons.refresh),
                              onPressed: () async {
                                eventPosterLink =
                                    await pickEventPoster(context);
                                setState(() {});
                              })
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              // eventPosterLink = await pickEventPoster(context);
                              // setState(() {});
                            },
                            child: OptimizedCacheImage(
                              useOldImageOnUrlChange: true,
                              imageUrl: eventPosterLink,
                              imageRenderMethodForWeb:
                                  ImageRenderMethodForWeb.HttpGet,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          ActionChip(
                              label: const Text("Edit"),
                              avatar: const Icon(Icons.edit_rounded),
                              onPressed: () async {
                                eventPosterLink =
                                    await pickEventPoster(context);
                                setState(() {});
                              })
                        ],
                      ),

                titleBox("Event Title"),
                TextFormField(
                  decoration: InputDecoration(
                    // label: Text('Full Name'),
                    hintText: "Add event name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  initialValue: title,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => title = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Event Description"),
                TextFormField(
                  initialValue: description,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => description = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Starting Date and Time"),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: CupertinoDatePicker(
                              onDateTimeChanged: (DateTime dt) {
                                setState(() {
                                  startTime = dt;
                                });
                              },
                              initialDateTime: DateTime.now(),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Done"))
                            ],
                          );
                        });
                  },
                  child: Text(
                    DateFormat().format(startTime).toString(),
                  ),
                ),
                titleBox("Registeration last Date and Time"),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: CupertinoDatePicker(
                              onDateTimeChanged: (DateTime dt) {
                                setState(() {
                                  lastRegisterationTime = dt;
                                });
                              },
                              initialDateTime: DateTime.now(),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Done"))
                            ],
                          );
                        });
                  },
                  child: Text(
                    DateFormat().format(lastRegisterationTime).toString(),
                  ),
                ),
                titleBox("Ending Date and Time"),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: CupertinoDatePicker(
                              onDateTimeChanged: (DateTime dt) {
                                setState(() {
                                  endTime = dt;
                                });
                              },
                              initialDateTime: DateTime.now(),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Done"))
                            ],
                          );
                        });
                  },
                  child: Text(
                    DateFormat().format(endTime).toString(),
                  ),
                ),
                titleBox("Announcements"),
                TextFormField(
                  initialValue: announcement,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => announcement = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Important Notes"),
                TextFormField(
                  initialValue: importantNote,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => importantNote = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                titleBox("Event Location"),
                TextFormField(
                  initialValue: location,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => location = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Event Coordinator"),
                TextFormField(
                  initialValue: eventCoordinator,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => eventCoordinator = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Event Coordinator Email"),
                TextFormField(
                  initialValue: eventCoordinatorEmail,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => eventCoordinatorEmail = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                titleBox("Event Coordinator Phone"),
                TextFormField(
                  initialValue: eventCoordinatorPhone,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => eventCoordinatorPhone = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Club Name"),
                TextFormField(
                  initialValue: clubName,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => clubName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                titleBox("Social Media Link for Updates"),
                TextFormField(
                  initialValue: socialMediaLinkForUpdates,
                  // The validator receives the text that the user has entered.
                  onChanged: (value) => socialMediaLinkForUpdates = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),

                // TimePickerDialog(initialTime: TimeOfDay.now()),
                // TextField(
                //   onTap: () async {
                //     DateTime? pickedDate = await showDatePicker(
                //         context: context, //context of current state
                //         initialDate: DateTime.now(),
                //         firstDate: DateTime(
                //             2000), //DateTime.now() - not to allow to choose before today.
                //         lastDate: DateTime(2101));

                //     if (pickedDate != null) {
                //       print(
                //           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                //       String formattedDate =
                //           DateFormat('yyyy-MM-dd').format(pickedDate);
                //       print(
                //           formattedDate); //formatted date output using intl package =>  2021-03-16
                //     } else {
                //       print("Date is not selected");
                //     }
                //   },
                // ),
                // Show Date Picker Here

                // const Text(
                //   "State",
                //   style:
                //       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                // const SizedBox(height: 8),
                // const SizedBox(height: 24),
                // const Text(
                //   "City",
                //   style:
                //       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                // const SizedBox(height: 8),
                // Row(
                //   children: [
                //     Text("Private Group"),
                //     ToggleButtons(isSelected: [true], children: [])
                //   ],
                // ),
                // const SizedBox(height: 24),

                ActionChip(
                  backgroundColor: Colors.black,
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wait Processing Data')),
                      );
                      // upload event poster

                      try {
                        // Upload file

                        if (isImageSelected) {
                          eventPosterLink =
                              await uploadArt(_fileBytes, _fileName);
                          Fluttertoast.showToast(msg: "Poster Uploaded");
                        }
                        submitData().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: "Event Successfully Added",
                              backgroundColor: Colors.green);
                          Get.back();
                        });
                      } on FirebaseException catch (e) {
                        // e.g, e.code == 'canceled'
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    }
                  },
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ])),
    );
  }

  InkWell saveTime(BuildContext context, Function callback) {
    return InkWell(
      onTap: () {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: CupertinoDatePicker(
                    onDateTimeChanged: (DateTime dt) {
                      setState(() {
                        callback(dt);
                      });
                    },
                    initialDateTime: DateTime.now(),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Done")),
                  ]);
            });
      },
      child: Text(
        DateFormat().format(endTime).toString(),
      ),
    );
  }
}
