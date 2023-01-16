import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelData {
  static Future<void> onSave(
      {required String eventName,
      required String fileName,
      required List<String> names}) async {
    // await Permission.storage.request();
    //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
    //var bytes = File(file).readAsBytesSync();
    var excel = Excel.createExcel();
    // or
    //var excel = Excel.decodeBytes(bytes);
    ///
    ///
    /// reading excel file values
    ///
    ///
    ///
    /// Change sheet from rtl to ltr and vice-versa i.e. (right-to-left -> left-to-right and vice-versa)
    ///
    // var sheet1rtl = excel['Sheet1'].isRTL;
    // excel['Sheet1'].isRTL = false;
    // print(
    //     'Sheet1: ((previous) isRTL: $sheet1rtl) ---> ((current) isRTL: ${excel['Sheet1'].isRTL})');

    // var sheet2rtl = excel['Sheet2'].isRTL;
    // excel['Sheet2'].isRTL = true;
    // print(
    //     'Sheet2: ((previous) isRTL: $sheet2rtl) ---> ((current) isRTL: ${excel['Sheet2'].isRTL})');

    ///
    ///
    /// declaring a cellStyle object
    ///
    ///
    CellStyle cellStyle = CellStyle(
      bold: false,
      italic: false,
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
      rotation: 0,
    );

    var sheet = excel[fileName];
    sheet.appendRow([
      'NAME',
      'ROLLNUMBER',
      'BRANCH',
    ]);
    excel.rename("Sheet1", fileName);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for (var element in names) {
      await users.doc(element).get().then((value) => {
            // add data to Excel
            sheet.appendRow([
              value['nickname'],
              value['rollnumber'],
              value['branch'],
            ])
          });
      // var cell = sheet.cell(CellIndex.indexByString("A1"));
      // cell.value = "Heya How are you I am fine ok goood night";
      // cell.cellStyle = cellStyle;
    }

    ///
    ///
    /// Iterating and changing values to desired type
    ///
    ///

    // excel.rename("mySheet", "myRenamedNewSheet");

    /// renaming the sheet

    /// deleting the shee

    /// unlinking the sheet if any link function is used !!

    /// appending rows and checking the time complexity of it
    bool isSet = excel.setDefaultSheet(sheet.sheetName);
    // isSet is bool which tells that whether the setting of default sheet is successful or not.
    if (isSet) {
      debugPrint("${sheet.sheetName} is set to default sheet.");
    } else {
      debugPrint("Unable to set ${sheet.sheetName} to default sheet.");
    }

    // Saving the file
    if (kIsWeb) {
      excel.save(fileName: "$eventName.xlsx"); 
    } else {
      late File file;
      var directory = await getApplicationDocumentsDirectory();
      List<int>? fileBytes = excel.save();
      //stopwatch.reset();
      // Directory(directory!.path + '/' + 'dir').create(recursive: true)
// The created directory is returned as a Future.
      //   .then((Directory director) {
      // print('Path of New Dir: ' + director.path);
      // if (fileBytes != null) {
      file = await File("${directory.path}/$eventName.xlsx")
          .writeAsBytes(fileBytes!);
      // debugPrint(file.path);
      // file.open();
      var o = await OpenFile.open(file.path);
      if (o.type == ResultType.done) {
        Fluttertoast.showToast(msg: "File saved at ${directory.path}");
      } else {
        Fluttertoast.showToast(msg: "File not saved");
      }
    }

    // }

    // });
    //print('saving executed in ${stopwatch.elapsed}');
  }
}
